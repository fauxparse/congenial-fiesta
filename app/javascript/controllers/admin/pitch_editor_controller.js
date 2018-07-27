import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['pile', 'gender', 'origin']

  set pile(pile) {
    this.selectButton('pile', pile)
  }

  set gender(gender) {
    this.selectButton('gender', gender)
  }

  set origin(origin) {
    this.selectButton('origin', origin)
  }

  success(e) {
    const [response, status, xhr] = e.detail

    this.pile = response.pile
    this.gender = response.gender
    this.origin = response.origin
  }

  selectButton(name, option) {
    this[`${name}Targets`].forEach(button => {
      if (button.value === option) {
        button.setAttribute('aria-selected', true)
      } else {
        button.removeAttribute('aria-selected')
      }
    })
  }
}
