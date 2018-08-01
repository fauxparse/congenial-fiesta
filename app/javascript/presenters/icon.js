const SVG_NAMESPACE = 'http://www.w3.org/2000/svg'
const XLINK_NAMESPACE = 'http://www.w3.org/1999/xlink'

export default class Icon {
  constructor(name) {
    this._name = name
  }

  get name() {
    return this._name
  }

  render({ width = 24, height = 24 } = {}) {
    const svg = document.createElementNS(SVG_NAMESPACE, 'svg')
    svg.setAttribute('width', width)
    svg.setAttribute('height', height)
    svg.setAttribute('viewBox', `0 0 ${width} ${height}`)
    svg.classList.add('icon')
    svg.classList.add(`icon--${this.name}`)
    const use = document.createElementNS(SVG_NAMESPACE, 'use')
    use.setAttributeNS(XLINK_NAMESPACE, 'xlink:href', '#' + this.name)
    svg.appendChild(use)
    return svg
  }

  appendTo(element) {
    const icon = this.render()
    element.appendChild(icon)
    return icon
  }
}
