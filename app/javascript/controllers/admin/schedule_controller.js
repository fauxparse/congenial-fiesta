import { Controller } from 'stimulus'

import fetch from '../../lib/fetch'
import moment from '../../lib/moment'

export default class extends Controller {
  static targets = ['form', 'delete', 'activityId', 'day', 'startTime', 'endTime']

  connect() {
    this.baseURL = this.formTarget.getAttribute('action')
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
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
    const modal = this.modal
    if (modal) {
      modal.title = title
    }
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
    this.activityIdTarget.value = id
    const activity = this.activities[id] || {}
    this.title = activity.name || 'Scheduled activity'
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

  get activities() {
    return this._activities || {}
  }

  set activities(activities) {
    this._activities = activities
  }

  startTimeChanged({ detail: { hours, minutes } }) {
    this._startTime = this.startTime.clone().hours(hours).minutes(minutes)
    this.endTime = this.endTime
  }

  endTimeChanged({ detail: { hours, minutes } }) {
    this._endTime = this.startTime.clone().hours(hours).minutes(minutes)
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

  load(id) {
    this.title = 'Loading…'
    this.modal.show()
    this.id = id
    fetch(this.url)
      .then(response => response.json())
      .then(({ activity_id, starts_at, ends_at }) => {
        this.activityId = activity_id
        this.startTime = starts_at
        this.endTime = ends_at
      })
  }

  delete() {
    fetch(this.url, { method: 'DELETE' })
      .then(response => response.json())
      .then(this.deleted)
  }

  submit(e) {
    e && e.preventDefault()
    this.formTarget.disabled = true
    const method = this.id ? 'PUT' : 'POST'
    fetch(this.url, {
      method,
      body: {
        authenticity_token: this.authenticityToken,
        schedule: {
          activity_id: this.activityId,
          starts_at: this.startTime.toISOString(),
          ends_at: this.endTime.toISOString()
        }
      }
    })
      .then(response => response.json())
      .then(this.id ? this.updated : this.created)
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
}
