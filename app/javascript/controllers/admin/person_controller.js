import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['name', 'email', 'admin', 'form']

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
    this.admin = person.admin
    this.modal.show()
  }

  submit(e) {
    e && e.preventDefault()
    this.disabled = true
    this.people.save({
      id: this.id,
      name: this.name,
      email: this.email,
      admin: this.admin
    }).then(() => {
      this.disabled = false
      this.modal.close()
    })
  }

  modalOpened() {
  }
}