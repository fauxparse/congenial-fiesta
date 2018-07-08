import { Controller } from 'stimulus'
import { EVENTS, eventPosition, absolutePosition } from '../../lib/events'
import BlockManager from './block_manager'

const ACTIVE_HEADER_CLASS = 'timetable__header-day--active'
const ACTIVE_CLASS = 'timetable__day--active'
const BLOCK_CLASS = 'timetable__block'
const SLOT_CLASS = 'timetable__slot'
const DRAG_THRESHOLD = 10

export default class extends Controller {
  static targets = ['back', 'next', 'header', 'day', 'slot']

  connect() {
    this.blocks = new BlockManager
    this.blocks.addEventListener('blocks:layout', this.updateLayout)
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

  slotForTime(time) {
    if (!this._slots) {
      this._slots = this.slotTargets.reduce(
        (memo, el) => Object.assign(memo, { [el.dataset.time]: el }),
        {}
      )
    }
    return this._slots[time]
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

  selected({ detail: { start, end } }) {
    const cell = this.cellAt(start.x, start.y)
    const y = Math.min(start.y, end.y)
    const height = Math.abs(end.y - start.y) + 1
    const block = document.createElement('div')
    block.classList.add(BLOCK_CLASS)
    block.style.height = `${height * 100}%`
    cell.appendChild(block)
    const id = this.blocks.insert({ x: start.x, y, height, data: block })
    block.setAttribute('data-id', id)
  }

  cellAt(x, y) {
    return this.element.querySelector(`[data-column="${x}"][data-row="${y}"]`)
  }

  updateLayout = ({ detail: blocks }) => {
    blocks.forEach(({ x, y, height, column, columns, data: block }) => {
      const cell = this.cellAt(x, y)
      cell.setAttribute('data-columns', columns)
      cell.appendChild(block)
      block.style.order = column
      block.style.height = `${height * 100}%`
      block.setAttribute('data-order', column)
    })
  }

  dragStart(e) {
    const method = e.touches ? 'touch' : 'mouse'
    const block = this.blockFromTarget(e.target)
    if (block) {
      e.preventDefault()
      e.stopPropagation()
      const id = block.getAttribute('data-id')
      const origin = eventPosition(e)
      const slot = block.parentElement
      const row = parseInt(slot.dataset.row, 10)
      const column = parseInt(slot.dataset.column, 10)
      const position = absolutePosition(slot)
      const offset = { x: origin.x - position.x, y: origin.y - position.y }
      const width = slot.offsetWidth
      const height = block.offsetHeight
      // const height = this.blocks.block(id).height
      const mode = offset.y > height - 8 ? 'resizing' : 'moving'
      block.classList.add(`${BLOCK_CLASS}--${mode}`)
      this.dragging = {
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
        height: this.blocks.block(id).height
      }

      this.addListener(method, 'move', this.dragMove)
      this.addListener(method, 'stop', this.dragStop)
      this.dragUpdate()
    }
  }

  dragMove = e => {
    const { updating, offset } = this.dragging
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
    const { position, pointer, origin, offset, id, block, width } = this.dragging
    if (!this.dragging.moving) {
      const dx = position.x - origin.x
      const dy = position.y - origin.y
      const distance = Math.sqrt(dx * dx + dy * dy)
      this.dragging.moving = distance > DRAG_THRESHOLD
    }
    const x = position.x - offset.x + pointer.x
    const y = position.y - offset.y + pointer.y
    const slot =
      Array.from(document.elementsFromPoint(x, y)).find(this.isSlot)
    if (slot) {
      this.dragging.column = parseInt(slot.dataset.column, 10)
      this.dragging.row = parseInt(slot.dataset.row, 10)
      const ghost = this.dragGhost()
      const slotPosition = absolutePosition(slot)
      ghost.style.transform =
        `translate(${slotPosition.x}px, ${slotPosition.y}px)`
    }
  }

  dragUpdateResize() {
    const { id, block, position: { y }, origin: { x } } = this.dragging
    const slot =
      Array.from(document.elementsFromPoint(x, y)).find(this.isSlot)
    if (slot) {
      const height = Math.max(parseInt(slot.dataset.row, 10) - parseInt(block.parentElement.dataset.row, 10), 0) + 1
      this.dragging.height = height
      this.dragGhost().style.height = `${height * slot.offsetHeight}px`
    }
  }

  dragGhost = () => {
    if (!this.dragging.ghost) {
      const { block, width, height } = this.dragging
      const ghost = document.createElement('div')
      const slotPosition = absolutePosition(block.parentElement)
      ghost.classList.add(BLOCK_CLASS)
      ghost.classList.add(`${BLOCK_CLASS}--ghost`)
      ghost.style.width = width + 'px'
      ghost.style.height = block.offsetHeight + 'px'
      ghost.style.transform =
        `translate(${slotPosition.x}px, ${slotPosition.y}px)`
      document.body.appendChild(ghost)
      this.dragging.ghost = ghost
    }
    return this.dragging.ghost
  }

  dragStop = e => {
    const { method, mode, block, ghost, id, row, column, height } = this.dragging
    this.blocks.update(id, { x: column, y: row, height })
    block.classList.remove(`${BLOCK_CLASS}--${mode}`)
    ghost && ghost.remove()
    this.removeListener(method, 'move', this.dragMove)
    this.removeListener(method, 'stop', this.dragStop)
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
    window.addEventListener(
      EVENTS[method][event],
      handler,
      { passive: false }
    )
  }

  removeListener(method, event, handler) {
    window.removeEventListener(EVENTS[method][event], handler)
  }

  isSlot(target) {
    return target.nodeType == 1 && target.classList.contains(SLOT_CLASS)
  }
}
