import curry from 'lodash/curry'
import partition from 'lodash/partition'

const normalize = String.prototype.normalize ?
  str => str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase() :
  str => str.toLowerCase()

export default class ActivityCollection {
  matchers = [
    (query, { name }) => normalize(name).match(query),
    (query, { presenters }) =>
      presenters.find(({ name }) => normalize(name).match(query))
  ]

  constructor(activities = {}) {
    this._activities = activities
  }

  get(id) {
    return this._activities[id]
  }

  find(query) {
    if (query) {
      const sorted = Object.values(this._activities)
        .sort((a, b) =>
          normalize(a.name).localeCompare(normalize(b.name))
        )
      return this.matchers
        .reduce(([matched, unmatched], matcher) => {
          const [matching, rest] = partition(unmatched, curry(matcher)(query))
          return [
            [...matched, ...matching],
            rest
          ]
        }, [[], sorted])
        .shift()
    } else {
      return []
    }
  }
}
