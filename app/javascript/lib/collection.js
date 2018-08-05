import _ from 'lodash'
_.mixin(require('lodash-inflection'))

import fetch from './fetch'
import normalize from './normalize'

export default class Collection {
  constructor(items = {}) {
    this.refresh(items)
  }

  get name() {
    return _.snakeCase(this.constructor.name.replace(/Collection$/, ''))
  }

  get plural() {
    return _.pluralize(this.name)
  }

  get singular() {
    return _.singularize(this.name)
  }

  get baseURL() {
    return this._baseURL || [this.urlPrefix, this.plural].join('/')
  }

  set baseURL(url) {
    this._baseURL = url
  }

  get urlPrefix() {
    return window.location.pathname.split('/').slice(0, 3).join('/')
  }

  url(id) {
    return id ? [this.baseURL, id].join('/') : this.baseURL
  }

  all() {
    return Object.values(this._items)
  }

  get(id) {
    return this._items[id]
  }

  set(id, item) {
    this._items[id] = item
  }

  update(id, attributes) {
    this.set(id, { ...(this.get(id) || {}), ...attributes })
  }

  map(fn) {
    return this.all().map(fn)
  }

  forEach(fn) {
    return this.all().forEach(fn)
  }

  refresh(items) {
    if (_.isArrayLikeObject(items)) {
      this._items = _.keyBy(items, item => item.id)
    } else {
      this._items = { ...items }
    }
    return this
  }

  find(query, includeAllWhenBlank = false) {
    if (query) {
      const sorted = this.all()
        .sort((a, b) =>
          normalize(a.name).localeCompare(normalize(b.name))
        )
      return this.matchers()
        .reduce(([matched, unmatched], matcher) => {
          const [matching, rest] =
            _.partition(unmatched, _.curry(matcher)(query))
          return [
            [...matched, ...matching],
            rest
          ]
        }, [[], sorted])
        .shift()
    } else {
      return includeAllWhenBlank ? this.all() : []
    }
  }

  matchers() {
    return [
      (query, { name }) => normalize(name).match(query)
    ]
  }

  create(attributes) {
    return this.save(attributes)
  }

  save(attributes) {
    const { id, ...attrs } = attributes
    return new Promise((resolve, reject) => {
      fetch(this.url(id), {
        method: id ? 'PUT' : 'POST',
        body: {
          [this.singular]: attrs
        }
      })
        .then(response => response.json())
        .then(item => {
          this.update(item.id, item)
          resolve(item)
        })
    })
  }

  fetch() {
    return new Promise((resolve, reject) => {
      fetch(this.url())
        .then(response => response.json())
        .then(data => {
          this.refresh(data[this.name] || data)
          resolve(this)
        })
    })
  }
}
