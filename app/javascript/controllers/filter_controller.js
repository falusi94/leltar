import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ['source', 'filterable']

  initialize() {
    this.active = !!this.sourceTarget.dataset['filterActive']
    this.name = this.sourceTarget.dataset['filterName']
    debugger
    this.update()
  }

  toggle() {
    this.active = !this.active
    this.update()
  }

  update() {
    if(this.active) {
      this.applyOnElements(e => e.classList.add('uk-hidden') )
      this.sourceTarget.textContent = 'Show ' + this.name
    } else {
      this.applyOnElements(e => e.classList.remove('uk-hidden') )
      this.sourceTarget.textContent = 'Hide ' + this.name
    }
  }

  applyOnElements(change) {
    this.filterableTargets.forEach(change)
  }
}
