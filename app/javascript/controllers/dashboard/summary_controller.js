import { Controller } from 'stimulus'
import { padStart, range } from 'lodash'
import Chart from '../../lib/chart'
import fetch from '../../lib/fetch'

const LOADING_CLASS = 'dashboard-widget--loading'

export default class extends Controller {
  static targets = [
    'count',
    'histogram',
    'workshopsProgress',
    'workshopsAllocation',
    'showsProgress',
    'showsAllocation'
  ]

  connect() {
    this.histogram
    this.load()
  }

  load() {
    this.element.classList.add(LOADING_CLASS)
    fetch(this.data.get('url'))
      .then(response => response.json())
      .then(this.loaded)
  }

  loaded = data => {
    this.countTarget.innerHTML = padStart(data.count.toString(), 4, '0')
    this.updateHistogram(data.histogram)
    this.updateCapacities(data.bookings)
    this.element.classList.remove(LOADING_CLASS)
  }

  updateHistogram(data) {
    const keys = Object.keys(data).map(n => parseInt(n, 10))
    const values = keys.map(key => data[key])
    const d = this.histogram.data
    d.labels.splice(0, d.labels.length, ...keys)
    d.datasets[0].data.splice(0, d.datasets[0].data.length, ...values)
    this.histogram.update()
    this.element.classList.remove(LOADING_CLASS)
  }

  updateCapacities(data) {
    Object.keys(data).forEach(key => {
      const { capacity, booked } = data[key]
      this[`${key}AllocationTarget`].innerText = `${booked} of ${capacity}`
      this[`${key}ProgressTarget`].style.transform =
        `scaleX(${Math.min(1.0, booked / capacity)})`
    })
  }

  get histogram() {
    if (!this._histogram) {
      this._histogram = new Chart(this.histogramTarget.getContext('2d'), {
        type: 'bar',
        data: {
          labels: range(12),
          datasets: [
            {
              data: new Array(12).fill(0),
              backgroundColor: '#ef4136'
            }
          ]
        },
        options: {
          legend: {
            display: false
          },
          scales: {
            xAxes: [{
              barPercentage: 0.9,
              categoryPercentage: 0.9,
              gridLines: {
                display: false,
                drawOnChartArea: false,
              }
            }],
            yAxes: [{
              offset: false,
              gridLines: {
                display: false,
                drawOnChartArea: false,
                drawBorder: false,
              },
              ticks: {
                beginAtZero: true,
                display: false
              }
            }]
          }
        }
      })
    }
    return this._histogram
  }
}
