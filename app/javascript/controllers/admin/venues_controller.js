import { Controller } from 'stimulus'
import fetch from '../../lib/fetch'
import VenueCollection from '../../collections/venues'

const LOADING_CLASS = 'venues--loading'

export default class extends Controller {
  static targets = ['map', 'geocoder', 'modal']

  connect() {
    this._venues = new VenueCollection()
    this.load()
    this.element.addEventListener('venue:created', this.venueCreated)
    this.element.addEventListener('venue:updated', this.venueUpdated)
    this.element.addEventListener('venue:deleted', this.venueDeleted)
  }

  get venues() {
    return this._venues
  }

  set venues(venues) {
    this._venues.refresh(venues)
    this.updateMarkers()
  }

  venue(id) {
    return this.venues.get(id)
  }

  get modal() {
    return this.application.getControllerForElementAndIdentifier(
      this.modalTarget,
      'admin--venue'
    )
  }

  get origin() {
    return [
      parseFloat(this.mapTarget.dataset.longitude),
      parseFloat(this.mapTarget.dataset.latitude)
    ]
  }

  get apiKey() {
    return this.mapTarget.dataset.apiKey
  }

  get mapStyle() {
    return this.mapTarget.dataset.style
  }

  get iconPath() {
    return this.mapTarget.dataset.icon
  }

  get map() {
    if (!this._map) {
      mapboxgl.accessToken = this.apiKey
      const map = new mapboxgl.Map({
        container: this.mapTarget,
        style: this.mapStyle,
        center: this.origin,
        zoom: 16
      })

      map.addControl(new mapboxgl.NavigationControl(), 'top-right')

      map.on('load', () => {
        this._mapLoaded = true
        map.addSource('venues', { type: 'geojson', data: this.venueData() })
        map.addLayer({
          id: 'venues',
          type: 'symbol',
          source: 'venues',
          layout: {
            'icon-image': 'marker',
            'icon-anchor': 'bottom',
            'icon-allow-overlap': true,
            'icon-ignore-placement': true,
            'icon-offset': ['get', 'offset'],
            'icon-rotate': ['get', 'rotation']
          }
        })
        map.on('click', 'venues', e => {
          const { geometry: { coordinates }, properties } = e.features[0]
          this.popup = new mapboxgl.Popup({ offset: 24 })
            .setLngLat(coordinates)
            .setHTML(this.venuePopup(properties))
            .addTo(map)
            .on('close', () => delete this.popup)
        })
        map.on('mousedown', 'venues', this.venueMouseDown)
        map.on('touchStart', 'venues', this.venueTouchStart)
      })

      this._map = map
    }
    return this._map
  }

  get geocoder() {
    if (!this._geocoder) {
      const geocoder = new MapboxGeocoder({
        accessToken: this.apiKey,
        country: 'nz',
        filter: item =>
          item.context
            .map(
              ({ id, text }) =>
                id.split('.').shift() === 'region' && text.match(/Wellington/)
            )
            .reduce((acc, cur) => acc || cur)
      })

      geocoder.on('result', e => {
        this.newVenue(e.result)
      })

      this._geocoder = geocoder
    }
    return this._geocoder
  }

  load() {
    this.element.classList.add(LOADING_CLASS)
    Promise.all([this.loadVenues(), this.loadMapbox()]).then(this.start)
  }

  start = () => {
    this.element.classList.remove(LOADING_CLASS)
    this.geocoderTarget.appendChild(this.geocoder.onAdd(this.map))
  }

  venueData() {
    return {
      type: 'FeatureCollection',
      features: this.venues.map(venue => ({
        type: 'Feature',
        properties: {
          id: venue.id,
          name: venue.name,
          address: venue.address,
          offset: [0, 0],
          rotation: 0
        },
        geometry: {
          type: 'Point',
          coordinates: [venue.longitude, venue.latitude]
        }
      }))
    }
  }

  loadVenues = () =>
    fetch(window.location.pathname)
      .then(response => response.json())
      .then(({ venues }) => (this.venues = venues))

  loadMapbox = () =>
    new Promise(resolve => {
      const checker = setInterval(() => {
        if (window.mapboxgl && window.MapboxGeocoder) {
          clearInterval(this.checker)
          resolve()
        }
      }, 100)
    })

  newVenue = ({ text, address, properties, geometry }) => {
    const [longitude, latitude] = geometry.coordinates
    const displayAddress = properties.address || [address, text].join(' ')
    this.modal.edit({
      name: text,
      address: displayAddress,
      latitude,
      longitude
    })
  }

  venueCreated = ({ detail: venue }) => {
    this.venues.update(venue.id, venue)
    this.updateMarkers()
  }

  venueUpdated = ({ detail: venue }) => {
    this.venues.update(venue.id, venue)
    this.updateMarkers()
  }

  venueDeleted = ({ detail: venue }) => {
    this.venues.remove(venue.id)
    this.updateMarkers()
  }

  updateMarkers() {
    if (this._mapLoaded) {
      this.map.getSource('venues').setData(this.venueData())
    }
  }

  venueMouseDown = e => {
    const feature = e.features[e.features.length - 1]
    const { id } = feature.properties
    const venue = this.venues.get(id)
    this._dragging = {
      venue,
      coordinates: e.lngLat,
      start: Date.now(),
      moved: false
    }
    e.preventDefault()
    this.map.on('mousemove', this.venueDragMove)
    this.map.once('mouseup', this.venueDragEnd)
  }

  venueTouchStart = e => {
    if (e.points.length === 1) {
      e.preventDefault()
      this.map.on('touchmove', this.venueDragMove)
      this.map.once('touchend', this.venueDragEnd)
    }
  }

  venueDragMove = e => {
    const coordinates = e.lngLat
    const dragging = this._dragging
    if (!dragging.moved) {
      dragging.moved = Date.now() - dragging.start > 150
    }
    if (dragging.moved && !dragging.update) {
      dragging.coordinates = e.lngLat
      dragging.update = requestAnimationFrame(this.venueDragUpdate)
    }
  }

  venueDragUpdate = () => {
    const { venue, coordinates } = this._dragging
    this.venues.update(venue.id, {
      latitude: coordinates.lat,
      longitude: coordinates.lng
    })
    this.updateMarkers()
    this._dragging.update = false
  }

  venueDragEnd = e => {
    cancelAnimationFrame(this._dragging.update)
    this.map.off('mousemove', this.venueDragMove)
    this.map.off('touchmove', this.venueDragMove)
    const { venue, moved, coordinates } = this._dragging
    if (moved) {
      this.modal.id = venue.id
      fetch(
        this.modal.url,
        { method: 'PUT', body: { venue: this.venue(venue.id) }}
      )
    }
    this._dragging = false
  }

  venuePopup({ name, address, id }) {
    return [
      `<h4>${name}</h4>`,
      `<address>${address}</address>`,
      '<div class="buttons">',
      `<button class="button" rel="edit" data-id="${id}">Edit</button>`,
      `<button class="button" rel="delete" data-id="${id}">Delete</button>`,
      '</div>'
    ].join('')
  }

  edit = venue => {
    if (this.popup) {
      this.popup.remove()
    }
    this.modal.edit(venue)
  }

  destroy = venue => {
    if (this.popup) {
      this.popup.remove()
    }
    this.modal.id = venue.id
    fetch(this.modal.url, { method: 'DELETE' })
      .then(() => {
        this.venues.remove(venue.id)
        this.updateMarkers()
      })
  }

  click = e => {
    const editButton = e.target.closest('.button[rel="edit"]')
    if (editButton) {
      this.edit(this.venue(editButton.dataset.id))
    } else {
      const deleteButton = e.target.closest('.button[rel="delete"]')
      if (deleteButton) {
        this.destroy(this.venue(deleteButton.dataset.id))
      }
    }
  }
}
