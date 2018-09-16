import { Controller } from 'stimulus'
import Clipboard from 'clipboard'
import Tooltip from 'tether-tooltip'

window.Tooltip = Tooltip

const COPIED_CLASS = 'clipboard--copied'

export default class extends Controller {
  static targets = ['copyButton']

  connect() {
    this.clipboard = new Clipboard(this.copyButtonTarget)
    this.clipboard.on('success', this.copied)
  }

  copied = e => {
    this.element.classList.add(COPIED_CLASS)
    setTimeout(() => this.element.classList.remove(COPIED_CLASS), 500)
    this.showTooltip()
  }

  showTooltip() {
    clearTimeout(this._hideTooltip)
    if (!this._tooltip) {
      this._tooltip = new Tooltip({
        target: this.copyButtonTarget,
        content: 'Copied!',
        openOn: '',
        position: 'top center'
      })
    }
    this._tooltip.open()
    setTimeout(() => this._tooltip.close(), 2000)
  }
}
