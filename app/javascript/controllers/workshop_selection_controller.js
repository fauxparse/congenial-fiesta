import { Controller } from 'stimulus'
import { keys, method, values } from 'lodash'

export default class extends Controller {
  static targets = ['cart', 'hiddenField']

  get cart() {
    return this.application.getControllerForElementAndIdentifier(
      this.cartTarget.firstElementChild,
      'cart'
    )
  }

  selectionChanged({ detail }) {
    const count = keys(detail).length
    this.cart.count = count
    this.cart.total = count * (6500 - (count - 1) * 500)
    this.hiddenFieldTargets.forEach(method('remove'))
    values(detail).forEach(this.addHiddenFields)
  }

  addHiddenFields = activities => {
    const fragment = document.createDocumentFragment()
    activities.forEach(({ id }, i) => {
      const input = document.createElement('input')
      input.setAttribute('type', 'hidden')
      input.setAttribute('name', `registration[workshops][${id}]`)
      input.setAttribute('value', i + 1)
      input.setAttribute('data-target', 'workshop-selection.hiddenField')
      fragment.appendChild(input)
    })
    this.element.appendChild(fragment)
  }
}
