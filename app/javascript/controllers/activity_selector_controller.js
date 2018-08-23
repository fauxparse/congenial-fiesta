import { Controller } from 'stimulus'
import {
  findIndex,
  groupBy,
  keyBy,
  property,
  uniq,
  upperFirst,
  values
} from 'lodash'

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
  static targets = ['activity']

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

  addClicked = e => {
    e.preventDefault()
    const id = e.target.closest('.activity').getAttribute('data-id')
    this.addActivity(this.activities[id])
  }

  addActivity(activity) {
    this.preferences[activity.slot].push(activity)
    this.updatePositions(activity.slot)
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
    activity.position = position
    if (position) {
      element.querySelector(
        '.activity__remove .button__text'
      ).innerText = `${upperFirst(ORDINALS[position])} choice`
      element.setAttribute('data-position', position)
    } else {
      element.removeAttribute('data-position')
    }
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
    const detail = this.selections
    const event =
      new CustomEvent('activities:select', { detail, bubbles: true })
    this.element.dispatchEvent(event)
  }
}
