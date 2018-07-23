import { Controller } from 'stimulus'

export default class extends Controller {
  close = e => {
    e && e.preventDefault()
    const height = this.element.offsetHeight
    this.element.classList.add('flash--closing')
    this.element.style.marginTop = `-${height}px`
    setTimeout(() => this.element.remove(), 300)
  }
}
