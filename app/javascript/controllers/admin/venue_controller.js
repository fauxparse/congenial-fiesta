import { Controller } from 'stimulus'
import autosize from 'autosize'

import fetch from '../../lib/fetch'
import { KEYS } from '../../lib/events'

export default class extends Controller {
  static targets = [
    'form',
    'cancel',
    'submit',
    'submitText',
    'delete',
    'name',
    'address',
    'latitude',
    'longitude'
  ]

  connect() {
    autosize(this.addressTarget)
    this.nameTarget.addEventListener('keypress', this.keyPress)
  }

  get url() {
    return [
      this.formTarget.getAttribute('action').replace(/\/$/, ''),
      this.id
    ].filter(x => x).join('/')
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  get id() {
    return this.data.get('venueId')
  }

  set id(id) {
    if (id) {
      this.data.set('venueId', id)
    } else {
      this.data.delete('venueId')
    }
    this.deleteTarget.style.display = id ? 'initial' : 'none'
    this.submitTextTarget.innerText = id ? this.submitTextTarget.dataset.saveText : this.submitTextTarget.dataset.createText
  }

  get name() {
    return this.nameTarget.value
  }

  set name(name) {
    this.nameTarget.value = name
    this.validate()
  }

  get address() {
    return this.addressTarget.value
  }

  set address(address) {
    this.addressTarget.value = address
    autosize.update(this.addressTarget)
    this.validate()
  }

  get latitude() {
    return this.latitudeTarget.value
  }

  set latitude(latitude) {
    this.latitudeTarget.value = latitude
  }

  get longitude() {
    return this.longitudeTarget.value
  }

  set longitude(longitude) {
    this.longitudeTarget.value = longitude
  }

  set disabled(disabled) {
    this.nameTarget.disabled = disabled
    this.addressTarget.disabled = disabled
    this.submitTarget.disabled = disabled
    this.cancelTarget.disabled = disabled
  }

  edit({ id, name, address, latitude, longitude }) {
    this.id = id
    this.name = name
    this.address = address
    this.latitude = latitude
    this.longitude = longitude
    this.modal.show()
  }

  destroy({ id }) {
    this.id = id
    this.deleteClicked()
  }

  deleteClicked(e) {
    e && e.stopPropagation()
    fetch(this.url, { method: 'DELETE' })
      .then(response => response.json())
      .then(venue => {
        this.modal.close()
        const event = new CustomEvent(
          'venue:deleted',
          { detail: venue, bubbles: true }
        )
        this.element.dispatchEvent(event)
      })
  }

  validate() {
    const invalid = !this.name || !this.address
    this.submitTarget.disabled = invalid
    return !invalid
  }

  modalOpened = () => setTimeout(() => this.nameTarget.focus())

  keyPress = e => {
    if (e.which === KEYS.ENTER) {
      e.preventDefault()
      this.submit()
    }
  }

  submit = e => {
    e && e.preventDefault()
    this.disabled = true
    fetch(
      this.url,
      {
        method: this.id ? 'PUT' : 'POST',
        body: {
          venue: {
            name: this.name,
            address: this.address,
            latitude: this.latitude,
            longitude: this.longitude
          }
        }
      }
    )
      .then(response => response.json())
      .then(venue => {
        this.disabled = false
        const event = new CustomEvent(
          `venue:${this.id ? 'updated' : 'created'}`,
          { detail: venue, bubbles: true }
        )
        this.element.dispatchEvent(event)
        this.modal.close()
      })
  }
}
