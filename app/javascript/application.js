// Entry point for the build script in your package.json

import "@hotwired/turbo"
import UIkit from "uikit"
import UIkitIcons from 'uikit/dist/js/uikit-icons'

window.UIkit = UIkit
UIkit.use(UIkitIcons)
