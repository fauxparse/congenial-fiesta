import { Controller } from 'stimulus'

import { KEYS } from '../lib/events'

const TRANSITION_DURATION = 300

export default class extends Controller {
  static targets = ['title', 'content']

  set title(text) {
    this.titleTarget.innerHTML = text
  }

  show() {
    const event = this.dispatchEvent('open')
    if (!event.defaultPrevented) {
      this.element.classList.add('modal--in')
      setTimeout(() => this.dispatchEvent('opened'), TRANSITION_DURATION)
      this.element.querySelector('.modal__body').scrollTop = 0
      this.element.focus()
    }
  }

  close(e) {
    this.hide()
  }

  hide(e) {
    if (!e || !e.defaultPrevented) {
      e && e.preventDefault()
      const event = this.dispatchEvent('close')
      const focused = this.element.querySelector(':focus')
      focused && focused.blur()
      this.element.classList.remove('modal--in')
      setTimeout(() => this.dispatchEvent('closed'), TRANSITION_DURATION)
    }
  }

  click(e) {
    e.stopPropagation()
  }

  keyDown(e) {
    if (e.which === KEYS.ESCAPE) {
      e.preventDefault()
      e.stopPropagation()
      this.close()
    }
  }

  dispatchEvent(eventName) {
    const event = new Event(`modal:${eventName}`, {
      bubbles: true,
      cancelable: true
    })
    this.element.dispatchEvent(event)
    return event
  }
}
