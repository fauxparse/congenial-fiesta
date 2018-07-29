import Collection from '../lib/collection'
import normalize from '../lib/normalize'

export default class People extends Collection {
  get singular() {
    return 'person'
  }

  get plural() {
    return 'people'
  }

  get self() {
    return this.get(this._selfId)
  }

  set self(person) {
    this._selfId = person.id || person || undefined
  }

  all() {
    return super.all().sort((a, b) =>
      normalize(a.name).localeCompare(normalize(b.name))
    )
  }

  matchers() {
    return [
      ...super.matchers(),
      (query, { email }) => normalize(email).match(query)
    ]
  }
}
