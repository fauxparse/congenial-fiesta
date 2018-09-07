import { Controller } from 'stimulus'
import Odometer from 'odometer'
import Packery from 'packery'
import Draggabilly from 'draggabilly'

window.odometerOptions = {
  format: '(,ddd).dd'
}

export default class extends Controller {
  static targets = ['widget']

  connect() {
    this.packery = new Packery(this.element, {
      itemSelector: '.dashboard-widget',
      gutter: 16
    })

    this.widgetTargets.forEach(widget => {
      const draggie = new Draggabilly(widget)
      this.packery.bindDraggabillyEvents(draggie)
    })
  }
}
