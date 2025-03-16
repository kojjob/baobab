import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["filtersPanel"]
  
  connect() {
    // Check if filters should be shown based on URL params
    if (window.location.search && window.location.search !== "?") {
      this.showFilters()
    }
  }
  
  toggleFilters() {
    if (this.hasFiltersPanelTarget) {
      this.filtersPanelTarget.classList.toggle("hidden")
    }
  }
  
  showFilters() {
    if (this.hasFiltersPanelTarget) {
      this.filtersPanelTarget.classList.remove("hidden")
    }
  }
  
  hideFilters() {
    if (this.hasFiltersPanelTarget) {
      this.filtersPanelTarget.classList.add("hidden")
    }
  }
}