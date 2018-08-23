import { Controller } from 'stimulus'
import { debounce } from 'lodash'
import fetch from '../lib/fetch'
import money from '../lib/money'

export default class extends Controller {
  static targets = ['count', 'total']

  _params = {}

  set count(value) {
    this.countTarget.setAttribute('data-count', value)
  }

  get total() {
    return parseInt(this.element.dataset.total, 10)
  }

  set total(value) {
    this.element.dataset.total = value
    const node = this.totalTarget.firstChild.firstChild
    node.textContent = money(value) + ' '
  }

  set loading(value) {
    if (value) {
      this.element.classList.add('cart--loading')
    } else {
      this.element.classList.remove('cart--loading')
    }
  }

  update(params) {
    this.loading = true
    this._params = { ...this._params, ...params }
    this.calculate()
  }

  calculate = debounce(() => {
    const { step, ...registration } = this._params

    fetch(
      '/register/cart',
      {
        method: 'post',
        body: {
          step,
          registration
        }
      }
    )
    .then(response => response.json())
    .then(this.updated)
  }, 250)

  updated = ({ count, total }) => {
    this.count = count
    this.total = total.amount
    this.loading = false
    const event =
      new CustomEvent('cart:updated', { detail: this, bubbles: true })
    this.element.dispatchEvent(event)
  }
}
