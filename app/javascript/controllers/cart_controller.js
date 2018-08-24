import { Controller } from 'stimulus'
import { debounce } from 'lodash'
import fetch from '../lib/fetch'
import money from '../lib/money'

export default class extends Controller {
  static targets = [
    'count',
    'total',
    'modal',
    'summaryCount',
    'summaryPrice',
    'summaryValue',
    'summaryTotal'
  ]

  _params = {}

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'modal'
    )
  }

  get count() {
    return parseInt(this.countTarget.getAttribute('data-count'), 10)
  }

  set count(value) {
    this.countTarget.setAttribute('data-count', value)
  }

  get total() {
    return parseInt(this.data.get('total'), 10)
  }

  set total(value) {
    this.data.set('total', value)
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

  updated = ({ count, total, per_workshop }) => {
    this.count = count
    this.total = total.amount
    this.perWorkshop = per_workshop.amount
    this.loading = false
    this.updateSummary()
    const event =
      new CustomEvent('cart:updated', { detail: this, bubbles: true })
    this.element.dispatchEvent(event)
  }

  updateSummary() {
    this.summaryCountTarget.setAttribute('data-count', this.count)
    this.summaryPriceTarget.firstChild.textContent =
      money(this.perWorkshop) + ' '
    this.summaryValueTarget.firstChild.textContent =
      money(this.count * this.perWorkshop) + ' '
    this.summaryTotalTarget.firstChild.textContent = money(this.total) + ' '
  }

  showDetails() {
    this.modal.show()
  }
}
