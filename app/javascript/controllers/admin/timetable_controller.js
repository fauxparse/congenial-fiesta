import { Controller } from 'stimulus'
import { EVENTS, eventPosition, absolutePosition } from '../../lib/events'
import fetch from '../../lib/fetch'
import BlockManager from './block_manager'

const ACTIVE_HEADER_CLASS = 'timetable__header-day--active'
const ACTIVE_CLASS = 'timetable__day--active'
const BLOCK_CLASS = 'timetable__block'
const SLOT_CLASS = 'timetable__slot'
const DRAG_THRESHOLD = 10

export default class extends Controller {
  static targets = ['back', 'next', 'header', 'day', 'slot', 'modal']

  connect() {
    this.blocks = new BlockManager()
    this.blocks.addEventListener('block:layout', this.updateLayout)
    this.blocks.addEventListener('block:deleted', this.deleteBlock)
    this.load()
  }

  get columns() {
    return this.dayTargets.length
  }

  get rows() {
    if (this._rows === undefined) {
      this._rows = this.dayTargets[0].querySelectorAll('[data-row]').length
    }
    return this._rows
  }

  get editor() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'admin--schedule'
    )
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'modal'
    )
  }

  get index() {
    return this.dayTargets.findIndex(target =>
      target.classList.contains(ACTIVE_CLASS)
    )
  }

  set index(index) {
    const oldIndex = this.index
    if (index != oldIndex && index >= 0 && index < this.dayTargets.length) {
      this.setActive(oldIndex, false)
      this.setActive(index, true)
      this.backTarget.disabled = index === 0
      this.nextTarget.disabled = index === this.dayTargets.length - 1
    }
  }

  get url() {
    return window.location.pathname.replace(/\/+$/, '')
  }

  setActive(index, active) {
    this.dayTargets[index].classList.toggle(ACTIVE_CLASS, active)
    this.headerTargets[index].classList.toggle(ACTIVE_HEADER_CLASS, active)
  }

  back() {
    this.index -= 1
  }

  next() {
    this.index += 1
  }

  load() {
    fetch(this.url)
      .then(response => response.json())
      .then(({ schedules }) => schedules.forEach(this.addBlock))
  }

  scheduleCreated({ detail: schedule }) {
    this.addBlock(schedule)
  }

  scheduleUpdated({ detail: schedule }) {
    const { id, starts_at, ends_at } = schedule
    const block = this.blocks.block(id)
    const startSlot = this.slotStartingAt(starts_at)
    const endSlot =
      this.slotEndingAt(ends_at) ||
      this.slotAt(startSlot.dataset.column, this.rows - 1)
    if (startSlot && endSlot) {
      const x = parseInt(startSlot.dataset.column, 10)
      const y = parseInt(startSlot.dataset.row, 10)
      const height = parseInt(endSlot.dataset.row, 10) - y + 1
      this.blocks.update(id, { x, y, height })
    }
  }

  scheduleDeleted({ detail: { id } }) {
    this.blocks.delete(id)
  }

  addBlock = ({ id, starts_at, ends_at }) => {
    const startSlot = this.slotStartingAt(starts_at)
    const endSlot =
      this.slotEndingAt(ends_at) ||
      this.slotAt(startSlot.dataset.column, this.rows - 1)
    if (startSlot && endSlot) {
      const x = parseInt(startSlot.dataset.column, 10)
      const y = parseInt(startSlot.dataset.row, 10)
      const height = parseInt(endSlot.dataset.row, 10) - y + 1
      const block = document.createElement('div')
      block.classList.add(BLOCK_CLASS)
      block.style.height = `${height * 100}%`
      startSlot.appendChild(block)
      block.setAttribute('data-id', id)
      this.blocks.insert({ id, x, y, height, data: block })
    }
  }

  selected({ detail: { start, end } }) {
    const slot = this.slotAt(start.x, start.y)
    const endSlot = this.slotAt(end.x, end.y)
    const y = Math.min(start.y, end.y)
    const height = Math.abs(end.y - start.y) + 1
    const { modal, editor } = this

    editor.title = 'New event'
    editor.id = undefined
    editor.startTime = slot.dataset.startTime
    editor.endTime = endSlot.dataset.endTime
    modal.show()
  }

  slotAt(x, y) {
    return this.element.querySelector(`[data-column="${x}"][data-row="${y}"]`)
  }

  updateLayout = ({ detail: blocks }) => {
    blocks.forEach(({ x, y, height, column, columns, data: block }) => {
      const slot = this.slotAt(x, y)
      slot.setAttribute('data-columns', columns)
      slot.appendChild(block)
      block.style.order = column
      block.style.height = `${height * 100}%`
      block.setAttribute('data-order', column)
    })
  }

  click(e) {
    const block = this.blockFromTarget(e.target)
    if (block) {
      this.editor.load(block.dataset.id)
    }
  }

  deleteBlock({ detail: block }) {
    block.data.remove()
  }

  dragStart(e) {
    const method = e.touches ? 'touch' : 'mouse'
    const block = this.blockFromTarget(e.target)
    if (block) {
      e.preventDefault()
      e.stopPropagation()
      const origin = eventPosition(e)
      this.dragging = {
        block,
        method,
        origin,
        started: false,
        startDelay: setTimeout(this.dragStarted, 300)
      }
      this.addListener(method, 'move', this.dragMove)
      this.addListener(method, 'stop', this.dragStop)
    }
  }

  dragStarted = () => {
    const { block, method, startDelay, origin } = this.dragging
    startDelay && clearTimeout(startDelay)
    const id = block.getAttribute('data-id')
    const slot = block.parentElement
    const row = parseInt(slot.dataset.row, 10)
    const column = parseInt(slot.dataset.column, 10)
    const position = absolutePosition(slot)
    const offset = { x: origin.x - position.x, y: origin.y - position.y }
    const width = slot.offsetWidth
    const height = block.offsetHeight
    const mode = offset.y > height - 8 ? 'resizing' : 'moving'
    block.classList.add(`${BLOCK_CLASS}--${mode}`)
    this.dragging = {
      started: true,
      block,
      id,
      method,
      mode,
      origin,
      position: origin,
      offset,
      pointer: { x: width / 2, y: 8 },
      moving: false,
      width,
      height: this.blocks.block(id).height,
      row,
      column
    }

    this.dragUpdate()
  }

  dragMove = e => {
    const { started, updating, offset } = this.dragging
    !started && this.dragStarted()
    this.dragging.position = eventPosition(e)
    if (!updating) {
      this.dragging.updating = requestAnimationFrame(this.dragUpdate)
    }
  }

  dragUpdate = () => {
    this.dragging.updating = false
    if (this.dragging.mode == 'moving') {
      this.dragUpdateMove()
    } else if (this.dragging.mode == 'resizing') {
      this.dragUpdateResize()
    }
  }

  dragUpdateMove() {
    const {
      position,
      pointer,
      origin,
      offset,
      id,
      block,
      width
    } = this.dragging
    if (!this.dragging.moving) {
      const dx = position.x - origin.x
      const dy = position.y - origin.y
      const distance = Math.sqrt(dx * dx + dy * dy)
      this.dragging.moving = distance > DRAG_THRESHOLD
    }
    const x = position.x - offset.x + pointer.x
    const y = position.y - offset.y + pointer.y
    const slot = Array.from(document.elementsFromPoint(x, y)).find(this.isSlot)
    if (slot) {
      this.dragging.column = parseInt(slot.dataset.column, 10)
      this.dragging.row = parseInt(slot.dataset.row, 10)
      const ghost = this.dragGhost()
      const slotPosition = absolutePosition(slot)
      ghost.style.transform = `translate(${slotPosition.x}px, ${
        slotPosition.y
      }px)`
    }
  }

  dragUpdateResize() {
    const {
      id,
      block,
      position: { y },
      origin: { x }
    } = this.dragging
    const slot = Array.from(document.elementsFromPoint(x, y)).find(this.isSlot)
    if (slot) {
      const height =
        Math.max(
          parseInt(slot.dataset.row, 10) -
            parseInt(block.parentElement.dataset.row, 10),
          0
        ) + 1
      this.dragging.height = height
      this.dragGhost().style.height = `${height}em`
    }
  }

  dragGhost = () => {
    if (!this.dragging.ghost) {
      const { block, mode, width, height } = this.dragging
      const ghost = block.cloneNode(true)
      const slotPosition = absolutePosition(block.parentElement)
      ghost.classList.add(`${BLOCK_CLASS}--ghost`)
      ghost.classList.remove(`${BLOCK_CLASS}--${mode}`)
      ghost.style.width = width + 'px'
      ghost.style.height = block.offsetHeight + 'px'
      ghost.style.transform = `translate(${slotPosition.x}px, ${
        slotPosition.y
      }px)`
      document.body.appendChild(ghost)
      this.dragging.ghost = ghost
    }
    return this.dragging.ghost
  }

  dragStop = e => {
    const {
      method,
      mode,
      started,
      startDelay,
      block,
      ghost,
      id,
      row,
      column,
      height
    } = this.dragging
    this.removeListener(method, 'move', this.dragMove)
    this.removeListener(method, 'stop', this.dragStop)
    if (started) {
      this.updateBlock(id, { x: column, y: row, height })
      block.classList.remove(`${BLOCK_CLASS}--${mode}`)
    } else {
      clearTimeout(startDelay)
      const event = new Event('block:clicked', {
        bubbles: true,
        cancelable: true,
        target: block
      })
      block.dispatchEvent(event)
    }
    ghost && ghost.remove()
    delete this.dragging
  }

  updateBlock(id, { x, y, height }) {
    this.blocks.update(id, { x, y, height })
    const startSlot = this.slotAt(x, y)
    const endSlot = this.slotAt(x, y + height - 1)
    const starts_at = startSlot.dataset.startTime
    const ends_at = endSlot.dataset.endTime
    fetch(`${this.url}/${id}`, {
      method: 'PUT',
      body: {
        schedule: {
          starts_at,
          ends_at
        }
      }
    })
  }

  blockFromTarget(el) {
    while (el) {
      if (el.classList && el.classList.contains(BLOCK_CLASS)) {
        return el
      } else {
        el = el.parentElement
      }
    }
    return undefined
  }

  addListener(method, event, handler) {
    window.addEventListener(EVENTS[method][event], handler, { passive: false })
  }

  removeListener(method, event, handler) {
    window.removeEventListener(EVENTS[method][event], handler)
  }

  isSlot(target) {
    return target.nodeType == 1 && target.classList.contains(SLOT_CLASS)
  }

  slotStartingAt(startTime) {
    return (
      this.element.querySelector(`[data-start-time="${startTime}"]`) ||
      this.firstSlotForDay(startTime)
    )
  }

  slotEndingAt(endTime) {
    return this.element.querySelector(`[data-end-time="${endTime}"]`)
  }

  firstSlotForDay(day) {
    return this.element.querySelector(
      `[data-day="${day.substr(0, 10)}"] [data-row]:first-child`
    )
  }

  lastSlotForDay(day) {
    return this.element.querySelector(
      `[data-day="${day.substr(0, 10)}"] [data-row]:last-child`
    )
  }
}
