import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab-state"
export default class extends Controller {
  initialize() {
    const queryString = window.location.search
    const queryParams = new URLSearchParams(queryString)

    this.activeTab = queryParams.get('tabState')

    if (this.activeTab) {
      document.addEventListener('turbo:load', () => {
        this.element.querySelector(`#${this.activeTab}`).click()
      })
    }
  }

  change(event) {
    this.activeTab = event.target.id

    const url = new URL(window.location)
    url.searchParams.set('tabState', this.activeTab)
    history.pushState(null, '', url)
  }
}
