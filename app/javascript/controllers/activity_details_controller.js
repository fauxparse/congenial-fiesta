import { Controller } from 'stimulus'
import { upperFirst } from 'lodash'
import fetch from '../lib/fetch'

const LOADING_CLASS = 'activity-details--loading'

export default class extends Controller {
  static targets = [
    'title',
    'description',
    'date',
    'times',
    'presenters',
    'levels',
    'bio'
  ]

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  load(id) {
    this.modal.show()

    this.element.classList.add(LOADING_CLASS)
    fetch(`/schedules/${id}`)
      .then(response => response.json())
      .then(this.loaded)
  }

  loaded = (data) => {
    const { name, description, date, times, presenters, levels, bios } = data

    this.titleTarget.innerText = name
    this.descriptionTarget.innerHTML = description
    this.presentersTarget.innerText = presenters
    this.timesTarget.innerText = `${date} • ${times}`
    this.bioTarget.innerHTML = bios.join('')
    this.levelsTarget.innerHTML =
      levels
      .map(level =>
        `<span class="activity__level" data-level="${level}">` +
        `<span>${upperFirst(level)}</span></span>`
      )
      .join('')

    this.element.classList.remove(LOADING_CLASS)
  }
}
