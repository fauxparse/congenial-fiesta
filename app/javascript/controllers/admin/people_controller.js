import { Controller } from 'stimulus'
import Turbolinks from 'turbolinks'
import fetch from '../../lib/fetch'
import normalize from '../../lib/normalize'
import People from '../../collections/people'

export default class extends Controller {
  static targets = ['search', 'list', 'source', 'person']

  connect() {
    this.searchTarget.focus()
    setTimeout(() => this.autocomplete.search())
  }

  get autocomplete() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'autocomplete'
    )
  }

  get people() {
    if (!this._people) {
      this._people = this.personTargets.map(person => ({
        id: person.dataset.id,
        name: person.querySelector('.person__name').innerText,
        data: { email: person.querySelector('.person__email').innerText }
      }))
    }
    return this._people
  }

  searchPeople({ detail: { query, results } }) {
    if (query) {
      const people = this.people.filter(this.matcher(query))
      results.push(...people)
    } else {
      results.push(...this.people)
    }
  }

  renderPerson({ detail }) {
    detail.result =
      this
      .sourceTarget
      .querySelector(`.person[data-id='${detail.id}']`)
      .cloneNode(true)
  }

  editPerson({ detail: { id } }) {
    Turbolinks.visit(window.location.pathname.replace(/\/?$/, `/${id}/edit`))
  }

  matcher = query => person => normalize(person.name).match(query)
}
