import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="text"
export default class extends Controller {
  static targets = ['source', 'mutable']

  copyLowerWords() {
    this.mutableTarget.value = (this.sourceTarget.value || '').toLowerCase().replace(/[^\w]/g, '-')
  }
}
