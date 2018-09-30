import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['confirmation']

  get confirmationDialog() {
    return this.application.getControllerForElementAndIdentifier(
      this.confirmationTarget,
      'modal'
    )
  }

  finalize(e) {
    e.preventDefault()
    this.confirmationDialog.show()
  }

  cancel(e) {
    e.preventDefault()
  }

  confirm(e) {
    this.confirmationDialog.hide()
  }
}
