import { Controller } from 'stimulus'
import fetch from '../../lib/fetch'

const LOADING_CLASS = 'dashboard-widget--loading'

export default class extends Controller {
  static targets = [
    'total',
    'internetBanking',
    'paypal',
    'paid',
    'outstanding'
  ]

  connect() {
    this.load()
  }

  load() {
    this.element.classList.add(LOADING_CLASS)
    fetch(this.data.get('url'))
      .then(response => response.json())
      .then(this.loaded)
  }

  loaded = data => {
    this.element.classList.remove(LOADING_CLASS)
    this.totalTarget.innerHTML = data.total
    this.internetBankingTarget.innerHTML = data.internet_banking
    this.paypalTarget.innerHTML = data.pay_pal
    this.paidTarget.innerHTML = data.paid
    this.outstandingTarget.innerHTML = data.outstanding
  }
}
