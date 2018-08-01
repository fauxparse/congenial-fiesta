import { Controller } from 'stimulus'
import autosize from 'autosize'
import People from '../../collections/people'
import Avatar from '../../presenters/avatar'
import Icon from '../../presenters/icon'

export default class extends Controller {
  static targets = ['autocomplete', 'presenters', 'presenter']

  connect() {
    autosize(this.element.querySelectorAll('textarea'))
    this.people.fetch().then(() => {
      this._presenters = this.presenterTargets.reduce((results, el) => ({
        ...results,
        [el.dataset.id]: this.people.get(el.dataset.id)
      }), {})
    })
  }

  get people() {
    if (!this._people) {
      this._people = new People()
    }
    return this._people
  }

  get autocomplete() {
    return this.application.getControllerForElementAndIdentifier(
      this.autocompleteTarget,
      'autocomplete'
    )
  }

  get presenters() {
    return this._presenters || {}
  }

  presenterClicked(e) {
    if (e.target.closest('[rel="delete"]')) {
      e.preventDefault()
      const row = e.target.closest('.activity-form__presenter')
      delete this.presenters[row.dataset.id]
      row.remove()
    }
  }

  searchPeople({ detail: { query, results } }) {
    const people =
      this.people.find(query)
        .map(person => ({
          id: person.id,
          name: person.name,
          data: person
        }))
        .filter(({ id }) => !this.presenters[id])
    results.push(...people)
  }

  renderPerson({ detail: { result, query, data: person } }) {
    const text = result.querySelector('.autocomplete__text')
    text.innerHTML = this.autocomplete.highlight(person.name, query)
  }

  addPresenter({ detail: { id, data: person, originalEvent } }) {
    originalEvent && originalEvent.preventDefault()
    this.presenters[id] = person
    const row = document.createElement('li')
    row.classList.add('activity-form__presenter')
    const hidden = document.createElement('input')
    hidden.setAttribute('type', 'hidden')
    hidden.name = 'activity[presenter_participant_ids][]'
    hidden.value = id
    row.appendChild(hidden)
    new Avatar(person).appendTo(row)
    const name = document.createElement('div')
    name.classList.add('presenter__name')
    name.innerHTML = person.name
    row.appendChild(name)
    const button = document.createElement('button')
    button.classList.add('button')
    button.classList.add('button--icon')
    button.setAttribute('rel', 'delete')
    new Icon('delete').appendTo(button).classList.add('button__icon')
    row.appendChild(button)
    this.presentersTarget.appendChild(row)
    this.autocomplete.clear()
  }
}
