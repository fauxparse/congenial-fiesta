import { Controller } from 'stimulus'
import fetch from '../../lib/fetch'
import moment from '../../lib/moment'

const TRANSITIONS = {
  pending: ['approved', 'cancelled'],
  approved: ['pending', 'cancelled', 'refunded'],
  cancelled: ['pending'],
  declined: ['pending'],
  refunded: ['cancelled']
}

export default class extends Controller {
  static targets = ['date', 'state', 'reference', 'action']

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  set state(state) {
    this.stateTarget.innerText = state
    this.actionTargets.forEach(button => {
      if (TRANSITIONS[state].includes(button.dataset.state)) {
        button.disabled = false
        button.removeAttribute('aria-hidden')
      } else {
        button.setAttribute('aria-hidden', true)
      }
    })
  }

  set date(date) {
    this.dateTarget.innerText = date.format('ddd D MMM, hh:mmA')
  }

  set reference(reference) {
    this.referenceTarget.innerText = reference
  }

  editPayment(url) {
    this.modal.show()
    this.load(url)
  }

  modalOpened() {
  }

  load(url) {
    this.url = url
    fetch(url)
      .then(response => response.json())
      .then(this.loaded)
  }

  loaded = ({ name, amount, state, time, reference }) => {
    this.modal.title = name
    this.state = state
    this.date = moment(time)
    this.reference = reference
  }

  changeState(e) {
    e.preventDefault()
    const state = e.target.closest('[data-state]').dataset.state
    this.actionTargets.forEach(button => button.disabled = true)

    fetch(this.url, { method: 'PUT', body: { payment: { state } } })
      .then(response => response.json())
      .then(this.changed)
  }

  changed = payment => {
    const event = new CustomEvent(
      'payment:updated',
      { detail: payment, bubbles: true }
    )
    this.element.dispatchEvent(event)
    this.modal.hide()
  }
}
