import { Controller } from 'stimulus'
import fetch from '../lib/fetch'

const DEFAULT_INTERVAL = 5000

export default class extends Controller {
  connect() {
    this.check()
  }

  get interval() {
    if (this.data.has('interval')) {
      return parseInt(this.data.get('interval'))
    } else {
      return DEFAULT_INTERVAL
    }
  }

  check = () => {
    fetch(window.location.href)
      .then(response => response.json())
      .then(({ status }) => {
        if (status === 'pending') {
          setTimeout(this.check, this.interval)
        } else {
          window.location.reload(true)
        }
      })
  }
}
