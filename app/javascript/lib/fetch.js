import 'whatwg-fetch'
import merge from 'lodash/merge'
import isObject from 'lodash/isObject'

const DEFAULT_OPTIONS = {
  method: 'GET',
  credentials: 'same-origin',
  headers: {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  }
}

const csrfHeaders = () => {
  const meta = document.querySelector('meta[name=csrf-token]')
  return meta ? { headers: { 'X-CSRF-Token': meta.content } } : {}
}

const mergeOptions = (...groups) =>
  groups.map(sanitizeOptions).reduce(merge, {})

const sanitizeOptions = (options = {}) => {
  if (isObject(options.body)) {
    options.body = JSON.stringify(options.body)
  }
  return options
}

export default (url, options = {}) =>
  fetch(url, mergeOptions(DEFAULT_OPTIONS, csrfHeaders(), options))
