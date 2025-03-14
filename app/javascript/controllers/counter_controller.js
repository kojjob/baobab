import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number"]
  
  connect() {
    this.observer = new IntersectionObserver(this.handleIntersection.bind(this), {
      threshold: 0.1,
      rootMargin: '0px 0px -20% 0px'
    })
    
    this.observer.observe(this.element)
  }
  
  disconnect() {
    this.observer.disconnect()
  }
  
  handleIntersection(entries) {
    const entry = entries[0]
    if (entry.isIntersecting) {
      this.startCounting()
      this.observer.unobserve(this.element)
    }
  }
  
  startCounting() {
    const from = parseInt(this.numberTarget.dataset.from) || 0
    const to = parseInt(this.numberTarget.dataset.to) || 0
    const duration = 2000
    const increment = (to - from) / duration * 16
    
    let current = from
    
    const updateCounter = () => {
      current += increment
      
      if (
        (increment > 0 && current >= to) || 
        (increment < 0 && current <= to)
      ) {
        current = to
        this.numberTarget.textContent = this.formatNumber(current)
        cancelAnimationFrame(this.animation)
        return
      }
      
      this.numberTarget.textContent = this.formatNumber(current)
      this.animation = requestAnimationFrame(updateCounter)
    }
    
    updateCounter()
  }
  
  formatNumber(number) {
    return new Intl.NumberFormat().format(Math.floor(number))
  }
}