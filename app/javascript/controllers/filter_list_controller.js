import AutocompleteController, { SELECTED_CLASS } from './autocomplete_controller'

const toggle = (element, visible) => {
  if (visible) {
    element.removeAttribute('aria-hidden')
  } else {
    element.setAttribute('aria-hidden', true)
  }
}

export default class extends AutocompleteController {
  renderResults(query) {
    const ids = this.results.map(result => result.id.toString())
    const isVisible = result => ids.indexOf(result.getAttribute('data-id')) > -1
    Array.from(this.listTarget.querySelectorAll('[data-id]'))
      .forEach(result => toggle(result, isVisible(result)))
  }

  set index(index) {
    const { length } = this.results
    if (length) {
      this._index = index % length
      const { id } = this.results[this._index]
      this.listTarget.querySelectorAll(`.${SELECTED_CLASS}`)
        .forEach(el => el.classList.remove(SELECTED_CLASS))

      const selected = this.listTarget.querySelector(`[data-id='${id}']`)
      if (selected) {
        selected.classList.add(SELECTED_CLASS)
        this.ensureVisible(selected)
        this.dispatch('highlight', this.results[this.index])
      }
    }
  }

  get index() {
    return this._index || 0
  }
}
