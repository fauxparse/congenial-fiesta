import { Controller } from 'stimulus'

const STATES = ['allocated', 'waitlisted', 'unselected']

export default class extends Controller {
  static targets = ['tab', 'pane', 'saveButton']

  connect() {
  }

  set tab(value) {
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tab === value) {
        tab.setAttribute('aria-selected', 'true')
      } else {
        tab.removeAttribute('aria-selected')
      }
    })
    this.paneTargets.forEach(tab => {
      if (tab.dataset.type === value) {
        tab.setAttribute('aria-selected', 'true')
      } else {
        tab.removeAttribute('aria-selected')
      }
    })
  }

  changeTab(e) {
    this.tab = e.target.dataset.tab
  }

  addActivity(e) {
    e.preventDefault()
    const id = this.activityIdFromEvent(e)
    this.setActivityState(id, 'allocated')
  }

  removeActivity(e) {
    e.preventDefault()
    const id = this.activityIdFromEvent(e)
    this.setActivityState(id, 'unselected')
  }

  waitlistActivity(e) {
    e.preventDefault()
    const id = this.activityIdFromEvent(e)
    const state = this.activityState(id)
    const newState = state === 'waitlisted' ? 'unselected' : 'waitlisted'
    this.setActivityState(id, newState)
  }

  activityIdFromEvent(e) {
    return e.target.closest('[data-id]').dataset.id
  }

  activityState(id) {
    const input = this.activityElement(id).querySelector('[type="hidden"]')
    return input.value
  }

  activityElement(id) {
    return this.element.querySelector(
      `.registration__activity[data-id='${id}']`
    )
  }

  setActivityState(id, state) {
    const element = this.activityElement(id)
    STATES.forEach(s => {
      element.classList.remove(`registration__activity--${s}`)
    })
    element.classList.add(`registration__activity--${state}`)
    element.querySelector('[type="hidden"]').value = state
  }
}
