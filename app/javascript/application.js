// Entry point for the build script in your package.json

import mrujs from 'mrujs';
import { MrujsTurbo } from 'mrujs/plugins'
import '@hotwired/turbo-rails'
import UIkit from 'uikit'
import UIkitIcons from 'uikit/dist/js/uikit-icons'

Turbo.config.forms.mode = 'optin'

import './controllers'
import './events'

window.UIkit = UIkit
UIkit.use(UIkitIcons)

mrujs.start({
  plugins: [
    MrujsTurbo()
  ]
})
