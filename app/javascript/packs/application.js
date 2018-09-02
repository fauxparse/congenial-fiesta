import '@stimulus/polyfills'

import Rails from 'rails-ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from 'activestorage'
import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

require('intersection-observer')

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const application = Application.start()
const context = require.context('../controllers', false, /\.js$/)
application.load(definitionsFromContext(context))
