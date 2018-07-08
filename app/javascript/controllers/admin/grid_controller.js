import { Controller } from 'stimulus'
import { EVENTS, eventPosition } from '../../lib/events'

const CELL_CLASS = 'grid__cell'
const SELECTION_CLASS = 'grid__selection'

export default class extends Controller {
  connect() {
    this.selectionStyle = this.data.get('selection-style') || 'rect'
  }

  get selection() {
    return this._selection
  }

  get selectionRect() {
    if (this._selection) {
      if (!this._selection.element) {
        const element = document.createElement('div')
        element.classList.add(SELECTION_CLASS)
        this._selection.element = element
      }
      return this._selection.element
    }
  }

  mouseDown(e) {
    this.startSelection(e, 'mouse')
  }

  touchStart(e) {
    this.startSelection(e, 'touch')
  }

  startSelection(e, method) {
    const cell = this.findCell(e.target)
    if (!this._selection && cell) {
      const position = eventPosition(e)
      const coordinates = this.cellCoordinates(cell)

      this._selection = {
        method,
        source: cell,
        origin: position,
        position,
        start: coordinates
      }

      this.addListener(method, 'move', this.moveSelection)
      this.addListener(method, 'stop', this.stopSelection)
      this.updateSelection()
    }
  }

  moveSelection = e => {
    e.preventDefault()
    this._selection.position = eventPosition(e)
    !this._updating && requestAnimationFrame(this.updateSelection)
  }

  updateSelection = () => {
    this._updating = false
    if (this._selection) {
      const { origin, position, end } = this._selection
      const columnOnly = false
      const rowOnly = false
      const { x } = columnOnly ? origin : position
      const { y } = rowOnly ? origin : position
      const cell =
        Array.from(document.elementsFromPoint(x, y)).find(this.isCell)
      if (cell) {
        const coords = this.cellCoordinates(cell)
        if (!end || coords.x !== end.x || coords.y !== end.y) {
          this._selection.end = coords
          this.updateSelectionRect()
        }
      }
    }
  }

  updateSelectionRect() {
    const { start, end } = this.selection
    const { x1, x2, y1, y2 } = this.resolveSelection(start, end)
    const width = (x2 - x1) + 1
    const height = (y2 - y1) + 1
    const cell = this.cellAt(x1, y1)
    cell.appendChild(this.selectionRect)
    this.selectionRect.style.width = `${width * 100}%`
    this.selectionRect.style.height = `${height * 100}%`
  }

  resolveSelection(start, end) {
    const x1 = Math.min(start.x, end.x)
    const x2 = Math.max(start.x, end.x)
    const y1 = Math.min(start.y, end.y)
    const y2 = Math.max(start.y, end.y)

    switch(this.selectionStyle) {
      case 'column':
        return { x1: start.x, x2: start.x, y1, y2 }
      case 'row':
        return { x1, x2, y1: start.y, y2: start.y }
      default:
        return { x1, x2, y1, y2 }
    }
  }

  stopSelection = e => {
    const { method } = this.selection
    this._updating && cancelAnimationFrame(this._updating)
    this.updateSelection()
    this.removeListener(method, 'move', this.moveSelection)
    this.removeListener(method, 'stop', this.stopSelection)
    this.selectionRect.remove()
    this.fireSelectionEvent()
    delete this._selection
  }

  fireSelectionEvent() {
    const event = new CustomEvent('grid:select', { detail: this.selection })
    this.element.dispatchEvent(event)
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

  findCell(target) {
    while(target) {
      if (this.isCell(target)) {
        return target
      }
      target = target.parentElement
    }
  }

  isCell(target) {
    return target.nodeType == 1 && target.classList.contains(CELL_CLASS)
  }

  cellCoordinates(cell) {
    return {
      x: parseInt(cell.dataset.column, 10),
      y: parseInt(cell.dataset.row, 10)
    }
  }

  cellAt(x, y) {
    return this.element.querySelector(
      `.${CELL_CLASS}[data-column="${x}"][data-row="${y}"]`
    )
  }
}
