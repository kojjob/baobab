import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "arrow"]
  
  connect() {
    // Close dropdown when clicking outside
    document.addEventListener('click', this.closeIfOutside.bind(this))
  }
  
  disconnect() {
    document.removeEventListener('click', this.closeIfOutside.bind(this))
  }
  
  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle('hidden')
    this.arrowTarget.classList.toggle('rotate-180')
  }
  
  close() {
    this.menuTarget.classList.add('hidden')
    this.arrowTarget.classList.remove('rotate-180')
  }
  
  closeIfOutside(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}