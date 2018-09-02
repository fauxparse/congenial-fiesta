import { Controller } from 'stimulus'
import { flatten, keys, method, values } from 'lodash'
import { tag } from 'tag'

export default class extends Controller {
  static targets = ['count', 'progress', 'limitModal']

  get activitySelector() {
    return this.application.getControllerForElementAndIdentifier(
      this.element.querySelector('.activity-selector'),
      'activity-selector'
    )
  }

  get limitModal() {
    return this.application.getControllerForElementAndIdentifier(
      this.limitModalTarget,
      'modal'
    )
  }

  connect() {
    setTimeout(this.updateProgress)
  }

  selectionChanged({ detail }) {
    this.updateProgress()
  }

  updateProgress = () => {
    const count = this.activitySelector.count
    const progress = Math.min(100, count * 100 / this.activitySelector.maximum)
    this.countTarget.innerText = count
    this.progressTarget.style.width = `${progress}%`
  }

  limitReached() {
    this.limitModal.show()
  }
}
