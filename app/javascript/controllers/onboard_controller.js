import { Controller } from 'stimulus'
import Flickity from 'flickity'

const LOCAL_STORAGE_KEY = 'nzif_onboarding'

export default class extends Controller {
  static targets = ['steps', 'step']

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  connect() {
    this.flickity = new Flickity(this.stepsTarget)
    if (this.shouldAutoShow()) {
      setTimeout(this.show)
    }
  }

  show = () => this.modal.show()

  back(e) {
    e && e.preventDefault()
    this.flickity.previous()
  }

  next(e) {
    e && e.preventDefault()
    this.flickity.next()
  }

  close(e) {
    e && e.preventDefault()
    this.modal.close()
    this.markAsRead()
  }

  opened() {
    this.flickity.select(0, false, true)
  }

  shouldAutoShow() {
    return this.data.has('auto') && !this.readBefore()
  }

  markAsRead() {
    const key = this.data.get('key')
    if (window.localStorage && key) {
      const read = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]')
      if (read.indexOf(key) === -1) read.push(key)
      localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(read))
    }
  }

  readBefore() {
    return window.localStorage &&
      JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY) || '[]')
        .indexOf(this.data.get('key')) > -1
  }
}
