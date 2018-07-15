import { Controller } from 'stimulus'

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
    }
  }

  close() {
    const event = this.dispatchEvent('close')
    if (!event.defaultPrevented) {
      const focused = this.element.querySelector(':focus')
      focused && focused.blur()
      this.element.classList.remove('modal--in')
      setTimeout(() => this.dispatchEvent('closed'), TRANSITION_DURATION)
    }
  }

  click(e) {
    e.stopPropagation()
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