import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['file', 'progress']

  connect() {
    addEventListener('direct-upload:initialize', this.onInitialize)
    addEventListener('direct-upload:progress', this.onProgress)
    addEventListener('direct-upload:error', this.onError)
    addEventListener('direct-upload:end', this.onEnd)
  }

  disconnect() {
    removeEventListener('direct-upload:initialize', this.onInitialize)
    removeEventListener('direct-upload:progress', this.onProgress)
    removeEventListener('direct-upload:error', this.onError)
    removeEventListener('direct-upload:end', this.onEnd)
  }

  submit() {
    this.fileTarget.form.submit()
  }

  setProgress(target, percentage) {
    if (target === this.fileTarget) {
      const pathLength = this.progressTarget.getTotalLength()
      this.progressTarget.style.strokeDasharray = pathLength
      this.progressTarget.style.strokeDashoffset =
        pathLength * (100.0 - percentage) / 100.0
    }
  }

  onInitialize = event => this.setProgress(event.target, 0)
  onProgress = event => this.setProgress(event.target, event.detail.progress)
  onError = event => this.setProgress(event.target, 0)
  onEnd = event => this.setProgress(event.target, 100)
}
