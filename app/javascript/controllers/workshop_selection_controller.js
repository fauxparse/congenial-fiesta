import { Controller } from 'stimulus'
import { flatten, keys, method, values } from 'lodash'

export default class extends Controller {
  static targets = ['cart', 'hiddenField']

  get cart() {
    return this.application.getControllerForElementAndIdentifier(
      this.cartTarget.firstElementChild,
      'cart'
    )
  }

  get activitySelector() {
    return this.application.getControllerForElementAndIdentifier(
      this.element.querySelector('.activity-selector'),
      'activity-selector'
    )
  }

  get selections() {
    return this.activitySelector.selections;
  }

  selectionChanged({ detail }) {
    this.hiddenFieldTargets.forEach(method('remove'))
    values(detail).forEach(this.addHiddenFields)
    const workshops =
      flatten(values(detail))
        .reduce((hash, { id, position }) => ({ ...hash, [id]: position }), {})
    this.cart.update({ step: 'workshops', workshops })
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
