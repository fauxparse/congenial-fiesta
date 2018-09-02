import { Controller } from 'stimulus'
import money from '../lib/money'

export default class extends Controller {
  static targets = ['steps', 'step']

  updateCart({ detail: cart }) {
    this
      .stepsTarget
      .querySelector('[data-step="payment"] .step__sublabel')
      .innerText = money(cart.total)
  }
}
