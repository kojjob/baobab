import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  
  connect() {
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      threshold: 0.1
    })
    
    this.textTargets.forEach(element => {
      this.observer.observe(element)
      
      // Set initial delay if specified
      const delay = element.dataset.delay || 0
      element.style.transitionDelay = `${delay}s`
    })
  }
  
  disconnect() {
    this.textTargets.forEach(element => {
      this.observer.unobserve(element)
    })
  }
  
  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible')
        this.observer.unobserve(entry.target)
      }
    })
  }
}