import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="event-dropdown"
export default class extends Controller {

  static targets = ["menu"];
  
  connect() {
    document.addEventListener("click", this.closeIfClickedOutside.bind(this));
  }
  
  disconnect() {
    document.removeEventListener("click", this.closeIfClickedOutside.bind(this));
  }
  
  toggle(event) {
    event.stopPropagation();
    this.menuTarget.classList.toggle("hidden");
  }
  
  closeIfClickedOutside(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
