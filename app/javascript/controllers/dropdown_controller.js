import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    // Close dropdown when clicking outside
    document.addEventListener("click", this.closeIfClickedOutside.bind(this))
  }
  
  disconnect() {
    document.removeEventListener("click", this.closeIfClickedOutside.bind(this))
  }
  
  toggle(event) {
    event.stopPropagation()
    
    const isVisible = !this.menuTarget.classList.contains("opacity-0")
    
    // Close any other open dropdowns first
    document.querySelectorAll('[data-dropdown-target="menu"]:not(.opacity-0):not(.invisible)').forEach(menu => {
      if (menu !== this.menuTarget) {
        menu.classList.add("opacity-0", "invisible", "translate-y-1")
      }
    })
    
    if (isVisible) {
      // Hide dropdown with animation
      this.menuTarget.classList.add("opacity-0", "invisible", "translate-y-1")
    } else {
      // Show dropdown with animation
      this.menuTarget.classList.remove("opacity-0", "invisible", "translate-y-1")
    }
  }
  
  closeIfClickedOutside(event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains("opacity-0")) {
      this.menuTarget.classList.add("opacity-0", "invisible", "translate-y-1")
    }
  }
}
