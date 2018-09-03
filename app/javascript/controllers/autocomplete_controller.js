import { Controller } from 'stimulus'
import escapeRegExp from 'lodash/escapeRegExp'

import { KEYS } from '../lib/events'
import normalize from '../lib/normalize'

const VISIBLE_CLASS = 'autocomplete--visible'
const RESULT_CLASS = 'autocomplete__result'
const SELECTED_CLASS = 'autocomplete__result--selected'

export default class extends Controller {
  static targets = ['input', 'results', 'list']

  connect() {
    this.inputTarget.addEventListener('input', this.textChanged)
    this.inputTarget.addEventListener('change', this.textChanged)
    this.inputTarget.addEventListener('keydown', this.keyDown)
    this.listTarget.addEventListener('click', this.resultClicked)
  }

  get results() {
    return this._results || []
  }

  set results(results) {
    this._results = results
  }

  get index() {
    return this._index || 0
  }

  set index(index) {
    const { length } = this.results
    if (length) {
      this._index = index % length
      const items = this.listTarget.querySelectorAll(`.${RESULT_CLASS}`)
      Array.from(items).forEach((item, i) =>
        item.classList.toggle(SELECTED_CLASS, index === i)
      )
      this.ensureVisible(items[this.index])
      this.dispatch('highlight', this.results[this.index])
    }
  }

  get selectedId() {
    const { index, results } = this
    if (results.length && index !== undefined && results[index]) {
      return results[index].id
    }
  }

  set selectedId(id) {
    if (id) {
      const str = id && id.toString()
      this.index =
        this.results.findIndex(result => result.id.toString() === str) || 0
    } else {
      this.index = 0
    }
  }

  get visible() {
    return this.element.classList.contains(VISIBLE_CLASS)
  }

  set visible(visible) {
    if (visible) {
      this.element.classList.add(VISIBLE_CLASS)
      this._results = []
      setTimeout(() => {
        this.search()
        this.inputTarget.focus()
      })
    } else {
      this.element.classList.remove(VISIBLE_CLASS)
      this.inputTarget.blur()
    }
  }

  show() {
    this.visible = true
  }

  hide() {
    this.visible = false
  }

  clear() {
    this.inputTarget.value = ''
    this.hide()
  }

  toggle(visible) {
    if (arguments.length) {
      this.visible = !!visible
    } else {
      this.visible = !this.visible
    }
  }

  focus() {
    if (!this.visible) {
      this.show()
    }
    this.textChanged()
  }

  blur() {}

  dispatch(eventName, detail = {}) {
    const event = new CustomEvent(`autocomplete:${eventName}`, {
      detail,
      bubbles: true
    })
    this.element.dispatchEvent(event)
    return event
  }

  textChanged = e => {
    if (!this.inputTarget.value) {
      this.index = this.selectedId = undefined
    }
    clearTimeout(this.autocompleteTimeout)
    this.autocompleteTimeout = setTimeout(this.search, 150)
  }

  keyDown = e => {
    if (e.which === KEYS.UP) {
      e.preventDefault()
      this.moveSelection(-1)
    } else if (e.which === KEYS.DOWN) {
      e.preventDefault()
      this.moveSelection(1)
    } else if (e.which === KEYS.ENTER) {
      e.preventDefault()
      this.confirmSelection()
    }
  }

  moveSelection(direction = 1) {
    const { length } = this.results
    this.index = length && (this.index + length + direction) % length
  }

  confirmSelection(originalEvent) {
    this.dispatch('select', { ...this.results[this.index], originalEvent })
  }

  searchRegExp = query =>
    new RegExp(query.trim().split(/\s+/).join('|'), 'gi')

  search = () => {
    if (!this.visible) {
      this.show()
    }
    const query = normalize(this.inputTarget.value)
    let re
    try {
      re = query && this.searchRegExp(query)
    } catch(_) {
      re = query && this.searchRegExp(escapeRegExp(query))
    }
    const {
      detail: { results }
    } = this.dispatch('search', { query: re, results: [] })
    this.results = results
    this.renderResults(re)
    this.index = 0
  }

  renderResults(query) {
    const fragment = document.createDocumentFragment()
    this.results.forEach(result => {
      fragment.appendChild(this.renderResult(query, result))
    })
    while (this.listTarget.firstChild) {
      this.listTarget.firstChild.remove()
    }
    this.listTarget.appendChild(fragment)
  }

  renderResult(query, { id, name, data }) {
    const result = document.createElement('div')
    result.classList.add('autocomplete__result')
    const text = document.createElement('div')
    text.classList.add('autocomplete__text')
    text.innerHTML = name
    result.dataset.id = id
    result.appendChild(text)
    const detail = { query, id, name, data, result }
    this.dispatch('render', detail)
    return detail.result
  }

  resultClicked = e => {
    const row = e.target.closest(`.${RESULT_CLASS}`)
    if (row) {
      this.selectedId = row.dataset.id
      this.confirmSelection(e)
    }
  }

  ensureVisible(element) {
    if (element) {
      const top = element.offsetTop
      const height = element.offsetHeight
      const scrollable = this.findScrollParent(this.resultsTarget)
      const viewportHeight = scrollable.offsetHeight

      if (top < scrollable.scrollTop) {
        scrollable.scrollTop = top
      } else if (top + height - scrollable.scrollTop > viewportHeight) {
        scrollable.scrollTop = top + height - viewportHeight
      }
    }
  }

  searchCollection(collection, query) {
    return collection
      .find(query)
      .map(item => ({
        id: item.id,
        name: item.name,
        data: item
      }))
  }

  findScrollParent(el, includeHidden = false) {
    let style = getComputedStyle(el)
    const excludeStaticParent = style.position === 'absolute'
    const re = includeHidden ? /(auto|scroll|hidden)/ : /(auto|scroll)/

    if (style.position === 'fixed') {
      return document.body
    }
    for (let parent = el.parentElement; parent; parent = parent.parentElement) {
      style = getComputedStyle(parent)
      if (excludeStaticParent && style.position === 'static') {
        continue
      }
      if (re.test(style.overflow + style.overflowY + style.overflowX)) {
        return parent
      }
    }

    return document.body
  }

  highlight(text, query) {
    if (query) {
      return text.replace(query, match => `<u>${match}</u>`)
    } else {
      return text
    }
  }
}
