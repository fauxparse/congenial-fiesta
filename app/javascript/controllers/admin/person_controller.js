import { Controller } from 'stimulus'
import autosize from 'autosize'
import Select from 'tether-select'

export default class extends Controller {
  static targets = ['name', 'email', 'city', 'bio', 'admin', 'form']

  connect() {
    autosize(this.bioTarget)
  }

  get countrySelect() {
    if (!this._countrySelect) {
      this._countrySelect =
        new Select({ el: this.element.querySelector('select') })
    }
    return this._countrySelect
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.element,
      'modal'
    )
  }

  get name() {
    return this.nameTarget.value || ''
  }

  set name(name) {
    this.nameTarget.value = name || ''
  }

  get email() {
    return this.emailTarget.value || ''
  }

  set email(email) {
    this.emailTarget.value = email || ''
  }

  get city() {
    return this.cityTarget.value || ''
  }

  set city(city) {
    this.cityTarget.value = city || ''
  }

  get country() {
    return this.countrySelect.value || ''
  }

  set country(country) {
    this.countrySelect.change(country || '')
  }

  get bio() {
    return this.bioTarget.value || ''
  }

  set bio(bio) {
    this.bioTarget.value = bio || ''
    autosize.update(this.bioTarget)
  }

  get id() {
    return this._id
  }

  set id(id) {
    this._id = this.people.get(id).id
    this.adminTarget.disabled = this.people.self.id === this._id
  }

  get admin() {
    return this.adminTarget.checked
  }

  set admin(admin) {
    this.adminTarget.checked = admin
  }

  get people() {
    return this._people
  }

  set people(people) {
    this._people = people
  }

  set disabled(disabled) {
    this.nameTarget.disabled = disabled
    this.formTarget.disabled = disabled
  }

  edit(person) {
    this.id = person.id
    this.name = person.name
    this.email = person.email
    this.city = person.city
    this.country = person.country_code
    this.bio = person.bio
    this.admin = person.admin
    this.modal.show()
  }

  submit(e) {
    e && e.preventDefault()
    this.disabled = true
    this.people
      .save({
        id: this.id,
        name: this.name,
        email: this.email,
        city: this.city,
        country_code: this.country,
        bio: this.bio,
        admin: this.admin
      })
      .then(person => {
        this.disabled = false
        const event = new CustomEvent('person:saved', {
          detail: { person },
          bubbles: true
        })
        this.element.dispatchEvent(event)
        this.modal.close()
      })
  }

  modalOpened() {}
}
