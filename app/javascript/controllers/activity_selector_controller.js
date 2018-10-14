import { Controller } from 'stimulus'
import {
  findIndex,
  groupBy,
  keyBy,
  method,
  property,
  uniq,
  upperFirst,
  values
} from 'lodash'
import { tag } from 'tag'

const ORDINALS = [
  undefined,
  'first',
  'second',
  'third',
  'fourth',
  'fifth',
  'sixth',
  'seventh',
  'eighth',
  'ninth',
  'tenth'
]

export default class extends Controller {
  static targets = ['activity', 'hiddenField', 'details']

  get type() {
    return this.data.get('type')
  }

  get details() {
    return this.application.getControllerForElementAndIdentifier(
      this.detailsTarget,
      'activity-details'
    )
  }

  get activities() {
    if (!this._activities) {
      this._activities = keyBy(
        this.activityTargets.map(el => ({
          id: el.getAttribute('data-id'),
          element: el,
          slot: el.getAttribute('data-slot'),
          position: parseInt(el.getAttribute('data-position'))
        })),
        property('id')
      )
    }
    return this._activities
  }

  get slots() {
    if (!this._slots) {
      this._slots = uniq(
        this.activityTargets.map(el => el.getAttribute('data-slot'))
      )
    }
    return this._slots
  }

  get preferences() {
    if (!this._preferences) {
      this._preferences = this.slots.reduce(
        (memo, slot) => ({ ...memo, [slot]: this.preferencesFor(slot) }),
        {}
      )
    }
    return this._preferences
  }

  get selections() {
    const activities =
      values(this.activities)
        .filter(activity => activity.position)
        .sort((a, b) => a.position - b.position)
    return groupBy(activities, property('slot'))
  }

  get count() {
    return values(this.preferences)
      .filter(slot => slot.length)
      .length
  }

  get maximum() {
    return parseInt(this.data.get('max') || 1000, 10)
  }

  get perSlot() {
    return parseInt(this.data.get('per-slot') || 1000, 10)
  }

  toggleClicked = e => {
    const el = e.target.closest('.activity')
    if (el.dataset.position) {
      this.removeClicked(e)
    } else {
      this.addClicked(e)
    }
  }

  addClicked = e => {
    e.preventDefault()
    const id = e.target.closest('.activity').getAttribute('data-id')
    const activity = this.activities[id]
    if (activity && !this.addActivity(activity)) {
      this.limitReached(activity)
    }
  }

  checkWaitlistLimit = e => {
    const waitlistCount =
      this.element.querySelectorAll('.join-waitlist:checked').length

    if (this.count + waitlistCount > this.maximum) {
      const id = e.target.closest('.activity').getAttribute('data-id')
      const activity = this.activities[id]
      e.target.checked = false
      this.limitReached(activity)
    }
  }

  limitReached(activity) {
    const event =
      new CustomEvent('activities:limit', { detail: activity, bubbles: true })
    this.element.dispatchEvent(event)
  }

  addActivity(activity) {
    if (this.perSlot === 1) {
      this.preferences[activity.slot] = []
    }
    this.preferences[activity.slot].push(activity)
    if (this.count > this.maximum) {
      this.removeActivity(activity)
      return false
    } else {
      this.updatePositions(activity.slot)
      return true
    }
  }

  removeClicked = e => {
    e.preventDefault()
    const id = e.target.closest('.activity').getAttribute('data-id')
    this.removeActivity(this.activities[id])
  }

  removeActivity(activity) {
    this.preferences[activity.slot].splice(activity.position - 1, 1)
    this.updatePositions(activity.slot)
  }

  updatePositions(slot) {
    values(this.activities)
      .filter(activity => activity.slot === slot)
      .forEach(activity =>
        this.updateActivityPosition(
          activity,
          findIndex(this.preferences[slot], activity) + 1
        )
      )

    this.changed()
  }

  updateActivityPosition(activity, position) {
    const { id, element } = activity
    const number = element.querySelector('.activity__position')
    activity.position = position
    if (position) {
      const text = element.querySelector('.activity__remove .button__text')
      text && (text.innerText = this.activeLabel(position))
      number && (number.innerText = position)
      element.setAttribute('data-position', position)
    } else {
      number && (number.innerText = '')
      element.removeAttribute('data-position')
    }
  }

  activeLabel(position) {
    const key = this.perSlot > 1 ? 'selectedMultiple' : 'selectedSingle'
    const template = this.element.dataset[key]
    return template.replace('%{position}', upperFirst(ORDINALS[position]))
  }

  preferencesFor(slot) {
    return values(this.activities)
      .filter(activity => activity.position && activity.slot === slot)
      .sort((a, b) => a.position - b.position)
  }

  activitiesIn(slot) {
    return Array.from(
      this.element.querySelector(`.activity[data-slot="${slot}"]`)
    )
  }

  changed() {
    this.updateHiddenFields()
    const detail = this.selections
    const event =
      new CustomEvent('activities:select', { detail, bubbles: true })
    this.element.dispatchEvent(event)
  }

  updateHiddenFields() {
    if (!this.data.get('demo')) {
      const selections = this.selections
      this.hiddenFieldTargets.forEach(method('remove'))
      values(selections).forEach(this.addHiddenFields)
    }
  }

  addHiddenFields = activities => {
    const fragment = document.createDocumentFragment()
    activities.forEach(({ id }, i) => {
      fragment.appendChild(
        tag('input', {
          type: 'hidden',
          name: `registration[${this.type}][${id}]`,
          value: i + 1,
          'data-target': 'activity-selector.hiddenField'
        })
      )
    })
    this.element.appendChild(fragment)
  }

  showDetails(e) {
    e.preventDefault()
    this.details.load(e.target.closest('.activity').dataset.id)
  }
}
