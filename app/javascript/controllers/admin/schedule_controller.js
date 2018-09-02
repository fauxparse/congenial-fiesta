import { Controller } from 'stimulus'
import autosize from 'autosize'

import fetch from '../../lib/fetch'
import moment from '../../lib/moment'
import ActivityCollection from '../../collections/activities'
import VenueCollection from '../../collections/venues'

const sentence = (items) => {
  if (!items.length) {
    return ''
  } else if (items.length === 1) {
    return items[0]
  } else if (items.length === 2) {
    return items.join(' and ')
  } else {
    const rest = items.slice(0, items.length - 1)
    const last = items[items.length - 1]
    return [rest.join(', '), last].join(', and ')
  }
}

export default class extends Controller {
  static targets = [
    'form',
    'delete',
    'activityId',
    'day',
    'venue',
    'startTime',
    'endTime',
    'activityName',
    'limited',
    'maximum',
    'submit'
  ]

  connect() {
    this.baseURL = this.formTarget.getAttribute('action')
    autosize(this.activityNameTarget)
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  get autocomplete() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'autocomplete'
    )
  }

  get startTimePicker() {
    return this.application.getControllerForElementAndIdentifier(
      this.startTimeTarget,
      'time-picker'
    )
  }

  get endTimePicker() {
    return this.application.getControllerForElementAndIdentifier(
      this.endTimeTarget,
      'time-picker'
    )
  }

  set title(title) {
    this.activityNameTarget.value = title
    this.autocomplete.hide()
    autosize.update(this.activityNameTarget)
  }

  get id() {
    return this.data.get('scheduleId')
  }

  set id(id) {
    if (id) {
      this.data.set('scheduleId', id)
    } else {
      this.data.delete('scheduleId')
    }
    this.deleteTarget.style.display = id ? 'initial' : 'none'
  }

  get activityId() {
    return this.activityIdTarget.value
  }

  set activityId(id) {
    this.activityIdTarget.value = id || null
    const activity = this.activities.get(id)
    this.title = (activity && activity.name) || ''
    this.submitTarget.disabled = !activity
  }

  get activity() {
    return this.activities.get(this.activityId)
  }

  get startTime() {
    return this._startTime
  }

  set startTime(time) {
    this._startTime = time && moment(time.valueOf())
    this.endTime = this.endTime
    this.date = this._startTime
    if (this._startTime) {
      this.startTimePicker.time = this._startTime.format('HH:mm')
    }
  }

  get endTime() {
    return this._endTime
  }

  set endTime(time) {
    const endTime = time && moment(time.valueOf())
    while (endTime && this.startTime && endTime.isBefore(this.startTime)) {
      endTime.add(1, 'day')
    }
    this._endTime = endTime
    if (this._endTime) {
      this.endTimePicker.time = this._endTime.format('HH:mm')
    }
  }

  set date(date) {
    this.dayTargets.forEach(day =>
      day.classList.toggle(
        'day-picker__day--selected',
        moment(day.dataset.date).isSame(date, 'day')
      )
    )
  }

  get venueId() {
    return this._venueId
  }

  set venueId(id) {
    this._venueId = (id || '').toString()
    this.venueTargets.forEach(venue =>
      venue.classList.toggle(
        'venue-picker__venue--selected',
        this._venueId === (venue.dataset.id || '') ||
          (!id && !venue.dataset.id)
      )
    )
  }

  get limited() {
    return this.limitedTarget.checked
  }

  get maximum() {
    return this.limited ? this.maximumTarget.value : undefined
  }

  set maximum(value) {
    if (value) {
      this.maximumTarget.value = value
    }
    this.limitedTarget.checked = !!value
  }

  get activities() {
    return this._activities || new ActivityCollection()
  }

  set activities(activities) {
    this._activities = activities
  }

  get activityTypes() {
    return this.activities.types
  }

  set activityTypes(types) {
    this.activities.types = types
  }

  get venues() {
    return this._venues || new VenueCollection()
  }

  set venues(venues) {
    this._venues = new VenueCollection(venues)
  }

  startTimeChanged({ detail: { hours, minutes } }) {
    this._startTime = this.startTime
      .clone()
      .hours(hours)
      .minutes(minutes)
    this.endTime = this.endTime
  }

  endTimeChanged({ detail: { hours, minutes } }) {
    this._endTime = this.startTime
      .clone()
      .hours(hours)
      .minutes(minutes)
    while (this._endTime.isBefore(this._startTime)) {
      this._endTime.add(1, 'day')
    }
  }

  get url() {
    const { id, baseURL } = this
    return id ? `${baseURL.replace(/\/+$/, '')}/${id}` : baseURL
  }

  get authenticityToken() {
    return this.formTarget.querySelector('[name="authenticity_token"]').value
  }

  dayClicked(e) {
    e.preventDefault()
    const target = e.target.closest('.day-picker__day')
    const day = moment(target.dataset.date)
    const startTime = this.startTime
      .clone()
      .year(day.year())
      .month(day.month())
      .date(day.date())
    const endTime = this.endTime
      .clone()
      .year(day.year())
      .month(day.month())
      .date(day.date())
    while (endTime.isBefore(startTime)) {
      endTime.add(1, 'day')
    }
    this.startTime = startTime
    this.endTime = endTime
  }

  venueClicked(e) {
    e.preventDefault()
    const target = e.target.closest('.venue-picker__venue')
    this.venueId = target.dataset.id
  }

  load(id) {
    this.title = 'Loading…'
    this.modal.show()
    this.id = id
    fetch(this.url)
      .then(response => response.json())
      .then(({ activity_id, venue_id, starts_at, ends_at, maximum }) => {
        this.activityId = activity_id
        this.venueId = venue_id
        this.startTime = starts_at
        this.endTime = ends_at
        this.maximumTarget.value = this.activity.maximum
        this.maximum = maximum
      })
  }

  modalOpened() {
    this.autocomplete.toggle(!this.activityId)
  }

  delete() {
    fetch(this.url, { method: 'DELETE' })
      .then(response => response.json())
      .then(this.deleted)
  }

  submit(e) {
    e && e.preventDefault()

    if (this.activityId) {
      this.formTarget.disabled = true
      const method = this.id ? 'PUT' : 'POST'
      fetch(this.url, {
        method,
        body: {
          authenticity_token: this.authenticityToken,
          schedule: {
            activity_id: this.activityId,
            venue_id: this.venueId || '',
            starts_at: this.startTime.toISOString(),
            ends_at: this.endTime.toISOString(),
            maximum: this.maximum || ''
          }
        }
      })
        .then(response => response.json())
        .then(this.id ? this.updated : this.created)
    } else {
      e && e.target.blur()
    }
  }

  created = schedule => {
    const event = new CustomEvent('schedule:created', {
      bubbles: true,
      detail: schedule
    })
    this.element.dispatchEvent(event)
    this.modal.close()
  }

  updated = schedule => {
    const event = new CustomEvent('schedule:updated', {
      bubbles: true,
      detail: schedule
    })
    this.element.dispatchEvent(event)
    this.modal.close()
  }

  deleted = schedule => {
    const event = new CustomEvent('schedule:deleted', {
      bubbles: true,
      detail: schedule
    })
    this.element.dispatchEvent(event)
    this.modal.close()
  }

  searchActivities = ({ detail: { query, results } }) => {
    const activities =
      this.autocomplete.searchCollection(this.activities, query)
    results.push(...activities)
    if (query) {
      results.push(...this.activities.types.map(type => ({
        id: type.name,
        name: `New ${type.label}`,
        data: {
          id: type.name,
          new: true,
          type: type.name,
          name: this.activityNameTarget.value
        }
      })))
    }
  }

  selectActivity({ detail: { data } }) {
    if (data.new) {
      const { id: type, name } = data
      this.activities.create({ type, name }).then(activity => {
        this.activityId = activity.id
        this.autocomplete.hide()
      })
    } else {
      this.activityId = data.id
      this.autocomplete.hide()
    }
  }

  limitedChanged() {
    this.maximumTarget.disabled = !this.limitedTarget.checked
    if (this.limitedTarget.checked) {
      this.maximumTarget.focus()
    }
  }

  renderActivity({ detail: { result, query, data: activity } }) {
    if (activity.new) {
      result.dataset.type = activity.type
      result.dataset.id = activity.type
    } else {
      const presenters = sentence(activity.presenters.map(p => p.name))
      const sub = [
        activity.type,
        this.autocomplete.highlight(presenters, query)
      ].filter(x => x).join(' • ')
      result.dataset.id = activity.id
      result.innerHTML =
        '<div class="autocomplete__text">' +
          this.autocomplete.highlight(activity.name, query) +
        '</div>' +
        '<div class="autocomplete__subtext">' +
          sub +
        '</div>'
    }
  }
}
