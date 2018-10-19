import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['text']

  connect() {
    autosize(this.textTarget)
  }
}
