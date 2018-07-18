import { Controller } from 'stimulus'
import { eventPosition } from '../lib/events'

const pad = n => `${n < 10 ? '0' : ''}${n}`

export default class extends Controller {
  static targets = ['time']

  connect() {
    this._time = 0
    this._offset = 0
    this.insertTimes()
    this.addEventListener('wheel', this.wheel)
    this.addEventListener('click', this.click)
    this.addEventListener('touchstart', this.touchStart)
  }

  addEventListener(event, handler) {
    this.element.addEventListener(event, handler, { passive: false })
  }

  removeEventListener(event, handler) {
    this.element.removeEventListener(event, handler)
  }

  get granularity() {
    return 30
  }

  get time() {
    return `${pad(this.hours)}:${pad(this.minutes)}`
  }

  set time(time) {
    const ampm = time.match(/[ap]m\s*$/i)
    const [hours, minutes] = time.split(':').map(n => parseInt(n, 10))
    const am = ampm ? ampm[0] == 'am' : hours < 12
    const pm = ampm ? ampm[0] == 'pm' : hours >= 12
    this._time = (hours % 12 + (pm ? 12 : 0)) * 60 + minutes
    this._offset =
      hours * (60 / this.granularity) + Math.floor(minutes / this.granularity)
    this.positionTimes()
  }

  get hours() {
    return Math.floor(this._time / 60)
  }

  get minutes() {
    return this._time % 60
  }

  get rowHeight() {
    if (!this._rowHeight) {
      this._rowHeight = this.timeTargets[0].offsetHeight
    }
    return this._rowHeight
  }

  insertTimes() {
    this.times().forEach(([hours, minutes], index) => {
      const row = document.createElement('div')
      row.classList.add('time-picker__time')
      row.innerHTML = this.formatTime(hours, minutes)
      row.dataset.time = hours * 60 + minutes
      row.dataset.index = index
      row.dataset.target = 'time-picker.time'
      this.element.appendChild(row)
    })
    this.positionTimes()
  }

  positionTimes() {
    const n = this.timeTargets.length
    this.timeTargets.forEach((target, i) => {
      const y = (i - this._offset + n + n / 2) % n - n / 2
      const opacity = Math.round(y) ? 0.375 : 1
      target.style.transform = `translateY(${y * 100}%)`
      target.style.opacity = opacity
    })
  }

  click = e => {
    e && e.preventDefault()
    const row = e.target.closest('[data-index]')
    if (row) {
      const index = parseInt(row.dataset.index, 10)
      const n = this.timeTargets.length
      const y = (index - this._offset + n + n / 2) % n - n / 2 + this._offset
      const time = parseInt(row.dataset.time, 10)
      if (time != this._time) {
        this._time = time
        this.changed()
      }
      this._target = Math.round(y) * this.rowHeight
      this._amplitude = this._target - this._offset * this.rowHeight
      this._timestamp = Date.now()
      this._animating = requestAnimationFrame(this.autoScroll)
    }
  }

  wheel = e => {
    e.preventDefault()
    cancelAnimationFrame(this._animating)
    this._offset += e.deltaY / this.rowHeight
    if (!this._updateRequested) {
      this._updateRequested = requestAnimationFrame(this.update)
    }
    clearTimeout(this._scrollEnded)
    this._scrollEnded = setTimeout(this.settle, 300)
  }

  touchStart = e => {
    this._pressed = true
    this._reference = eventPosition(e).y
    this._velocity = this._amplitude = 0
    this._frame = this._offset
    this._timestamp = Date.now()
    clearInterval(this._ticker)
    this._ticker = setInterval(this.track, 100)

    e.preventDefault()
    e.stopPropagation()
    this.addEventListener('touchmove', this.touchMove)
    this.addEventListener('touchend', this.touchEnd)
    return false
  }

  touchMove = e => {
    if (this._pressed) {
      const { y } = eventPosition(e)
      const delta = this._reference - y
      this._reference = y
      this._offset += delta * 1.0 / this.rowHeight
      cancelAnimationFrame(this._animationRequested)
      if (!this._updateRequested) {
        this._updateRequested = requestAnimationFrame(this.update)
      }
    }
  }

  touchEnd = e => {
    this._pressed = true
    clearInterval(this._ticker)
    if (this._velocity > 10 || this._velocity < -10) {
      this._amplitude = 0.8 * this._velocity
      this._target =
        Math.round(this._offset + this._amplitude / this.rowHeight) *
        this.rowHeight
      this._timestamp = Date.now()
      requestAnimationFrame(this.autoScroll)
    } else if (e.target.closest('[data-index]')) {
      this.click(e)
    }

    e.preventDefault()
    e.stopPropagation()
    this.removeEventListener('touchmove', this.touchMove)
    this.removeEventListener('touchend', this.touchEnd)
    return false
  }

  track = e => {
    const now = Date.now()
    const elapsed = now - this._timestamp
    this._timestamp = now
    const delta = (this._offset - this._frame) * this.rowHeight
    this._frame = this._offset

    const v = 1000 * delta / (1 + elapsed)
    this._velocity = 0.8 * v + 0.2 * this._velocity
  }

  autoScroll = () => {
    if (this._amplitude) {
      const elapsed = Date.now() - this._timestamp
      const delta = -this._amplitude * Math.exp(-elapsed / 300)
      if (delta > 0.5 || delta < -0.5) {
        this._offset = (this._target + delta) / this.rowHeight
        this._animating = requestAnimationFrame(this.autoScroll)
      } else {
        this._offset = this._target / this.rowHeight
      }
      this.update()
    }
  }

  update = () => {
    this._updateRequested = false
    this.positionTimes()
    const n = this.timeTargets.length
    const d = this._offset >= 0 ? 0 : Math.floor(this._offset) * n
    const t = (Math.round(this._offset) - d) % n
    const time = (t % n) / (60.0 / this.granularity) * 60
    if (time != this._time) {
      this._time = time
      this.changed()
    }
  }

  settle = () => {
    this._target = Math.round(this._offset) * this.rowHeight
    this._amplitude = this._target - this._offset * this.rowHeight
    this._timestamp = Date.now()
    this._animating = requestAnimationFrame(this.autoScroll)
  }

  times() {
    return new Array(24)
      .fill(0)
      .map((_, h) => h)
      .reduce(
        (times, h) => [
          ...times,
          ...new Array(60 / this.granularity)
            .fill(0)
            .map((_, m) => [h, m * this.granularity])
        ],
        []
      )
  }

  formatTime(hours, minutes) {
    const h = (hours + 11) % 12 + 1
    return `${pad(h)}:${pad(minutes)}${hours < 12 ? 'am' : 'pm'}`
  }

  changed() {
    if (!this._changing) {
      this._changing = true
      const event = new CustomEvent('change', {
        bubbles: true,
        detail: {
          time: this.time,
          hours: this.hours,
          minutes: this.minutes
        }
      })
      this.element.dispatchEvent(event)
      delete this._changing
    }
  }
}
