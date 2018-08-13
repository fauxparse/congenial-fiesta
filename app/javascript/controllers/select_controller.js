import { Controller } from 'stimulus'
import Select from 'tether-select'

export default class extends Controller {
  connect() {
    console.log('connect')
    new Select({ el: this.element })
  }
}
