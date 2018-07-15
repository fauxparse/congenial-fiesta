import curry from 'lodash/curry'
import partition from 'lodash/partition'

import fetch from './fetch'

const normalize = String.prototype.normalize ?
  str => str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase() :
  str => str.toLowerCase()

export default class ActivityCollection {
  matchers = [
    (query, { name }) => normalize(name).match(query),
    (query, { presenters }) =>
      presenters.find(({ name }) => normalize(name).match(query))
  ]

  constructor(activities = {}, types = []) {
    this._activities = { ...activities }
    this._types = types.slice()
  }

  get types() {
    return this._types || []
  }

  set types(types) {
    this._types = types.slice()
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

  create({ name, type }) {
    return new Promise((resolve, reject) => {
      fetch('/admin/2018/activities', {
        method: 'POST',
        body: {
          activity: { name, type }
        }
      })
        .then(response => response.json())
        .then(activity => {
          this._activities[activity.id] = activity
          resolve(activity)
        })
    })
  }
}
