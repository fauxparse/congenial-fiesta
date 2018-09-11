import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['saveButton']

  connect() {
    this.element.addEventListener('activities:select', this.selectionChanged)
  }

  selectionChanged = (e) => {
    const count = Object.keys(e.detail).length
    e.target.querySelector('.activity-count').innerText = count
    this.saveButtonTarget.disabled = false
  }
}
