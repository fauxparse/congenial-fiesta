import 'mdn-polyfills/Element.prototype.closest'

import Rails from 'rails-ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from 'activestorage'
import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(context))
