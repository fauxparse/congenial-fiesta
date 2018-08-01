import Icon from './icon'

export default class Avatar {
  constructor(person) {
    this._person = person
  }

  get person() {
    return this._person
  }

  render() {
    const avatar = document.createElement('div')
    avatar.classList.add('avatar')
    if (this.person.avatar) {
      const img = document.createElement('img')
      img.src = this.person.avatar
      img.alt = this.person.name
      avatar.appendChild(img)
    } else {
      new Icon('user').appendTo(avatar)
    }
    return avatar
  }

  appendTo(element) {
    const avatar = this.render()
    element.appendChild(avatar)
    return avatar
  }
}
