import { Controller } from 'stimulus'
import { flatten, keys, method, values } from 'lodash'
import { tag } from 'tag'

export default class extends Controller {
  static targets = ['cart', 'hiddenField']

  get cart() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
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
      fragment.appendChild(
        tag('input', {
          type: 'hidden',
          name: `registration[workshops][${id}]`,
          value: i + 1,
          'data-target': 'workshop-selection.hiddenField'
        })
      )
    })
    this.element.appendChild(fragment)
  }
}
