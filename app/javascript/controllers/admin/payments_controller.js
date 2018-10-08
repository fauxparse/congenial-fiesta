import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['modal', 'payment']

  get editor() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'admin--payment'
    )
  }

  editPayment(e) {
    e.preventDefault()
    this.editor.editPayment(e.target.closest('[href]').getAttribute('href'))
  }

  paymentUpdated({ detail: { id } }) {
    const payment = this.element.querySelector(`.payment[data-id="${id}"]`)
    if (payment) {
      payment.remove()
    }
  }
}
