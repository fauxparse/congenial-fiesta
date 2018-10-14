import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['description']

  connect() {
    autosize(this.descriptionTarget)
    this.descriptionTarget.focus()
  }
}
