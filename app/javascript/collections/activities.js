import Collection from '../lib/collection'
import fetch from '../lib/fetch'
import normalize from '../lib/normalize'

export default class ActivityCollection extends Collection {
  constructor(activities = {}, types = []) {
    super(activities)
    this._types = types.slice()
  }

  get types() {
    if (!this._types) {
      this._types = new Collection
    }
    return this._types
  }

  set types(types) {
    this.types.refresh(types)
  }

  matchers() {
    return [
      ...super.matchers(),
      (query, { presenters }) =>
        presenters.find(({ name }) => normalize(name).match(query))
    ]
  }
}
