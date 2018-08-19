export default class VenueCollection {
  get name() {
    return 'venue'
  }

  refresh(venues) {
    this._venues =
      venues.reduce((hash, venue) => ({ ...hash, [venue.id.toString()]: venue }), {})
  }

  get(id) {
    return this._venues[id]
  }

  update(id, attrs = {}) {
    this._venues[id] = { ...(this.get(id) || {}), ...attrs }
  }

  remove(id) {
    delete this._venues[id]
  }

  all() {
    return Object.values(this._venues)
  }

  map(fn) {
    return this.all().map(fn)
  }
}
