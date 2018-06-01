import { Controller } from 'stimulus'
import Select from 'tether-select'
import autosize from 'autosize'

export default class extends Controller {
  connect() {
    autosize(this.element.querySelectorAll('textarea[data-autosize]'))
    Array
      .from(this.element.querySelectorAll('select'))
      .forEach(el => new Select({ el }))
  }
}
