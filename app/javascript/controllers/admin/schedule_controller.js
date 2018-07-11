import { Controller } from 'stimulus'
import fetch from '../../lib/fetch'

export default class extends Controller {
  static targets = ['form', 'delete', 'activityId', 'startTime', 'endTime']

  connect() {
    this.baseURL = this.formTarget.getAttribute('action')
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
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
  }

  get startTime() {
    return this.startTimeTarget.value
  }

  set startTime(time) {
    this.startTimeTarget.value = time
  }

  get endTime() {
    return this.endTimeTarget.value
  }

  set endTime(time) {
    this.endTimeTarget.value = time
  }

  get url() {
    const { id, baseURL } = this
    return id ? `${baseURL.replace(/\/+$/, '')}/${id}` : baseURL
  }

  get authenticityToken() {
    return this.formTarget.querySelector('[name="authenticity_token"]').value
  }

  load(id) {
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
    fetch(
      this.url,
      {
        method,
        body: {
          authenticity_token: this.authenticityToken,
          schedule: {
            activity_id: this.activityId,
            starts_at: this.startTime,
            ends_at: this.endTime
          }
        }
      }
    )
    .then(response => response.json())
    .then(this.id ? this.updated : this.created)
  }

  created = (schedule) => {
    const event = new CustomEvent(
      'schedule:created',
      { bubbles: true, detail: schedule }
    )
    this.element.dispatchEvent(event)
    this.modal.close()
  }

  updated = (schedule) => {
    const event = new CustomEvent(
      'schedule:updated',
      { bubbles: true, detail: schedule }
    )
    this.element.dispatchEvent(event)
    this.modal.close()
  }

  deleted = (schedule) => {
    const event = new CustomEvent(
      'schedule:deleted',
      { bubbles: true, detail: schedule }
    )
    this.element.dispatchEvent(event)
    this.modal.close()
  }
}
