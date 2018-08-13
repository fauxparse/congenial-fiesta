import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['bookmark']

  connect() {
    this.observer = new IntersectionObserver(this.observe)
    this.observer.observe(this.bookmark)
  }

  disconnect() {
    this.observer.unobserve()
  }

  observe = entries => {
    if (entries[0].intersectionRatio > 0) {
      this.finished()
    }
  }

  get bookmark() {
    if (!this.bookmarkTargets[0]) {
      const bookmark = document.createElement('div')
      bookmark.setAttribute('data-target', 'reading.bookmark')
      this.element.appendChild(bookmark)
    }
    return this.bookmarkTargets[0]
  }

  finished() {
    const event = new CustomEvent('reading:finished', { bubbles: true })
    this.element.dispatchEvent(event)
  }
}
