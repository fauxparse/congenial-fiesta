import { Controller } from 'stimulus'
import Packery from 'packery'
import Draggabilly from 'draggabilly'
import fetch from '../../lib/fetch'

export default class extends Controller {
  static targets = ['participant']

  connect() {
    this.packery = new Packery(this.element, {
      itemSelector: '.waitlist__participant'
    })

    this.participantTargets.forEach(participant => {
      const draggie = new Draggabilly(participant, {
        handle: '.icon--reorder'
      })
      this.packery.bindDraggabillyEvents(draggie)
    })

    this.packery.on('dragItemPositioned', this.reordered)
  }

  cancelSubmit(e) {
    e.preventDefault()
  }

  reordered = () => {
    const positions = this.packery.getItemElements()
      .map((el, i) => [el, i + 1])
      .reduce((acc, [el, position]) => ({
        ...acc,
        [el.dataset.id]: position
      }), {})
    this.save(positions)
  }

  save(positions) {
    fetch(this.element.action, {
      method: 'put',
      body: {
        waitlist: positions
      }
    })
  }
}
