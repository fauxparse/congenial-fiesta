import { Controller } from 'stimulus'
import { padStart } from 'lodash'

const formatMoney = amount =>
  [
    '$',
    amount < 0 ? '-' : '',
    Math.floor(Math.abs(amount / 100)).toString(),
    '.',
    padStart((Math.abs(amount) % 100).toString(), 2, '0')
  ].join('')

export default class extends Controller {
  static targets = ['count', 'total']

  set count(value) {
    this.countTarget.setAttribute('data-count', value)
  }

  set total(value) {
    const node = this.totalTarget.firstChild.firstChild
    node.textContent = formatMoney(value) + ' '
  }
}
