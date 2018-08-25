import { Controller } from 'stimulus'
import { flatten, keys, values } from 'lodash'

export default class extends Controller {
  static targets = ['cart']

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

  selectionChanged({ detail }) {
    const workshops =
      flatten(values(detail))
        .reduce((hash, { id, position }) => ({ ...hash, [id]: position }), {})
    this.cart.update({ step: 'workshops', workshops })
  }

  help(e) {
    e && e.preventDefault()
    const help = this.application.getControllerForElementAndIdentifier(
      document.querySelector('.workshop-onboarding'),
      'onboard'
    )
    help && help.show()
  }
}
