import { Controller } from 'stimulus'

const VISIBLE_CLASS = 'autocomplete--visible'
const RESULT_CLASS = 'autocomplete__result'
const SELECTED_CLASS = 'autocomplete__result--selected'

const KEYS = {
  ESCAPE: 27,
  ENTER: 13,
  UP: 38,
  DOWN: 40
}

export default class extends Controller {
  static targets = ['input', 'results', 'list']

  connect() {
    this.inputTarget.addEventListener('change', this.textChanged)
    this.inputTarget.addEventListener('keydown', this.keyDown)
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
    }
  }

  get selectedId() {
    const { index, results } = this
    if (results.length && index !== undefined) {
      return results[index].id
    }
  }

  set selectedId(id) {
    this.index = id && this.results.findIndex(result => result.id === id) || 0
  }

  get visible() {
    return this.element.classList.contains(VISIBLE_CLASS)
  }

  set visible(visible) {
    this.element.classList.toggle(VISIBLE_CLASS, visible)
  }

  show() {
    this.visible = true
    this.inputTarget.focus()
  }

  hide() {
    this.visible = false
    this.inputTarget.blur()
  }

  focus() {
    if (!this.visible) {
      this.show()
    }
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

  confirmSelection() {
    this.dispatch('select', this.results[this.index])
  }

  search = () => {
    const query = this.inputTarget.value
    const selectedId = this.selectedId
    const re = query && new RegExp(query.trim().split(/\s+/).join('|'), 'gi')
    const {
      detail: { results }
    } = this.dispatch('search', { query: re, results: [] })
    this.results = results
    this.renderResults(re)
    this.selectedId = selectedId
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
    result.appendChild(text)
    this.dispatch('render', { query, name, data, result })
    return result
  }
}
