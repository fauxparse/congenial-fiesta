import { Controller } from 'stimulus'
import fetch from '../../lib/fetch'
import People from '../../collections/people'

export default class extends Controller {
  static targets = ['search', 'list', 'checkboxIcon', 'modal']

  connect() {
    this.load()
    this.searchTarget.focus()
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'admin--person'
    )
  }

  get autocomplete() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'autocomplete'
    )
  }

  get people() {
    if (!this._people) {
      this._people = new People()
    }
    return this._people
  }

  set people(people) {
    this.people.refresh(people)
    this.modal.people = this.people
  }

  get selection() {
    if (!this._selection) {
      this._selection = new Set()
    }
    return this._selection
  }

  load() {
    this.element.classList.add('people--loading')
    fetch(window.location.pathname)
      .then(response => response.json())
      .then(({ people, self }) => {
        this.people = people
        this.people.self = self
        this.element.classList.remove('people--loading')
        this.autocomplete.search()
      })
  }

  searchPeople({ detail: { query, results } }) {
    const people = this.people.find(query, true).map(person => ({
          id: person.id,
          name: person.name,
          data: person
        }))
    results.push(...people)
  }

  renderPerson({ detail: { result, query, data: person } }) {
    let el
    while (el = result.firstChild) {
      el.remove()
    }
    result.classList.add('person')
    const element = this.createElementWithClass('person', 'li')
    const label = document.createElement('label')
    const checkbox = document.createElement('input')
    checkbox.setAttribute('type', 'checkbox')
    checkbox.checked = this.selection.has(person.id)
    label.appendChild(checkbox)
    label.appendChild(this.checkboxIcon())
    result.appendChild(label)
    const details = this.createElementWithClass('person__details')
    const name = this.createElementWithClass('person__name')
    name.innerHTML = this.autocomplete.highlight(person.name, query)
    const email = this.createElementWithClass('person__email')
    email.innerHTML = this.autocomplete.highlight(person.email, query)
    details.appendChild(name)
    details.appendChild(email)
    result.appendChild(details)
    result.dataset.id = person.id
  }

  checkboxIcon() {
    const icon = this.checkboxIconTarget.cloneNode(true)
    icon.style.display = 'block'
    return icon
  }

  createElementWithClass(klass, name = 'div') {
    const el = document.createElement(name)
    el.classList.add(klass)
    return el
  }

  editPerson({ detail: { id, originalEvent } }) {
    const label = originalEvent && originalEvent.target.closest('label')
    if (!label) {
      this.modal.edit(this.people.get(id))
    }
  }

  selectPerson({ target }) {
    const id = target.closest('.person').dataset.id
    if (target.checked) {
      this.selection.add(id)
    } else {
      this.selection.delete(id)
    }
  }

  personSaved({ detail: { person } }) {
    const listItem = this.element.querySelector(`[data-id="${person.id}"]`)
    if (listItem) {
      this.renderPerson({
        detail: {
          data: person,
          result: listItem
        }
      })
    }
  }
}
