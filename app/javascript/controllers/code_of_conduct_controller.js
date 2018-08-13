import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['checkbox']

  enable() {
    console.log('enable')
    this.checkboxTarget.removeAttribute('disabled')
  }
}
