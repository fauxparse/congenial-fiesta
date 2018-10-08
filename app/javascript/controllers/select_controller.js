import { Controller } from 'stimulus'
import Select from 'tether-select'

export default class extends Controller {
  connect() {
    new Select({ el: this.element })
  }
}
