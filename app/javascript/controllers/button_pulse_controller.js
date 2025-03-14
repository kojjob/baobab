import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.pulse()
  }
  
  pulse() {
    this.element.classList.add('animate-pulse')
    setTimeout(() => {
      this.element.classList.remove('animate-pulse')
      setTimeout(() => {
        if (this.element) this.pulse()
      }, 5000)
    }, 1000)
  }
}