import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="access-checkbox"
export default class extends Controller {
  static targets = ['admin', 'readAll', 'writeAll']

  initialize() {
    this.update()
  }

  update() {
    if (this.adminTarget.checked) {
      this.readAllTarget.disabled = true
      this.readAllTarget.checked = true
      this.writeAllTarget.disabled = true
      this.writeAllTarget.checked = true
    }
    else {
      this.readAllTarget.disabled = false
      this.writeAllTarget.disabled = false
    }
  }
}
