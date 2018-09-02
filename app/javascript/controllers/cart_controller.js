import { Controller } from 'stimulus'
import { debounce } from 'lodash'
import Drop from 'tether-drop'
import { tag } from 'tag'
import fetch from '../lib/fetch'
import money from '../lib/money'

export default class extends Controller {
  static targets = [
    'cart',
    'count',
    'total',
    'modal',
    'summaryCount',
    'summaryPrice',
    'summaryValue',
    'summaryTotal'
  ]

  _params = {}

  connect() {
    this.drop = new Drop({
      target: this.cartTarget,
      classes: 'cart__summary',
      content: this.renderSummary,
      openOn: 'hover',
      hoverCloseDelay: 500,
      remove: true,
      tetherOptions: {
        attachment: 'top right',
        targetAttachment: 'bottom right'
      }
    })
  }

  get count() {
    return parseInt(this.countTarget.getAttribute('data-count'), 10)
  }

  set count(value) {
    this.countTarget.setAttribute('data-count', value)
  }

  get total() {
    return parseInt(this.cartTarget.dataset.total, 10)
  }

  set total(value) {
    this.cartTarget.dataset.total = value
    const node = this.totalTarget.firstChild.firstChild
    node.textContent = money(value) + ' '
  }

  get perWorkshop() {
    return parseInt(this.cartTarget.dataset.each, 10)
  }

  set loading(value) {
    if (value) {
      this.cartTarget.classList.add('cart--loading')
    } else {
      this.cartTarget.classList.remove('cart--loading')
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
    this.loading = false
    const event =
      new CustomEvent('cart:updated', { detail: this, bubbles: true })
    this.element.dispatchEvent(event)
  }

  renderSummary = () =>
    tag(
      'div',
      { class: 'cart__workshops' },
      [
        tag('span', { class: 'count', data: { count: this.count } }),
        '&nbsp;',
        tag('span', {
          class: 'item',
          data: { singular: 'workshop', plural: 'workshops' }
        }),
        '&nbsp;',
        '@',
        '&nbsp;',
        tag('span', { class: 'money' }, money(this.perWorkshop)),
        '&nbsp;=&nbsp;',
        tag(
          'div',
          { class: 'cart__savings' },
          [
            this.count < 2 ? '' : tag(
              'del',
              {},
              [
                tag('span', { class: 'money' }, money(this.perWorkshop * this.count)),
              ]
            ),
            tag('span', { class: 'money total' }, [
              money(this.total),
              '&nbsp;',
              tag('span', { class: 'currency' }, 'NZD')
            ])
          ]
        )
      ]
    )
}
