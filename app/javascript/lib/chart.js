import { Chart } from 'chart.js'
import { merge } from 'lodash'

merge(Chart.defaults.global, {
  defaultFontFamily: 'Work Sans',
  tooltips: {
    displayColors: false,
    callbacks: {
      title: () => []
    }
  }
})

export default Chart

