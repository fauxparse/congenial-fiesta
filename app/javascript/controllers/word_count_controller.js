import { Controller } from 'stimulus'

const SVG = 'http://www.w3.org/2000/svg'
const RADIUS = 7

const countWords = string =>
  (string
    .replace(/[^\w\s]|_/g, '')
    .replace(/\s+/g, ' ')
    .toLowerCase()
    .match(/\b[a-z\d]+\b/g) || []
  ).length

export default class extends Controller {
  static targets = [ 'editor', 'counter' ]

  connect() {
    this.addProgressIndicator()
    this.min = parseInt(this.data.get('min'))
    this.max = parseInt(this.data.get('max'))
    this.editorTarget.addEventListener('change', this.update)
    this.editorTarget.addEventListener('input', this.update)
    this.update()
  }

  addProgressIndicator() {
    const svg = document.createElementNS(SVG, 'svg')
    const circle = document.createElementNS(SVG, 'circle')
    const path = document.createElementNS(SVG, 'path')
    svg.setAttribute(
      'viewBox',
      `${-1 - RADIUS} ${-1 - RADIUS} ${RADIUS * 2 + 2} ${RADIUS * 2 + 2}`
    )
    circle.setAttribute('r', 7)
    path.setAttribute('d', [
      'M', 0, -RADIUS,
      'A', RADIUS, RADIUS, 0, 0, 1, 0, RADIUS,
      'A', RADIUS, RADIUS, 0, 0, 1, 0, -RADIUS
    ].join(' '))
    svg.appendChild(circle)
    svg.appendChild(path)
    this.counterTarget.insertBefore(svg, this.counterTarget.firstChild)
    this.indicator = path
  }

  update = () => {
    const count = countWords(this.editorTarget.value)
    const circumference = Math.PI * RADIUS * 2
    const progress = Math.min(this.min, count) * circumference / this.min
    this.indicator.style.strokeDasharray = circumference
    this.indicator.style.strokeDashoffset = circumference - progress
    this.counterTarget.classList.toggle('word-limit-exceeded', count > this.max)
    this.counterTarget.setAttribute('title', `${count} words`)
  }
}
