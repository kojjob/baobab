import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('mouseenter', this.onMouseEnter.bind(this))
    this.element.addEventListener('mouseleave', this.onMouseLeave.bind(this))
  }
  
  disconnect() {
    this.element.removeEventListener('mouseenter', this.onMouseEnter.bind(this))
    this.element.removeEventListener('mouseleave', this.onMouseLeave.bind(this))
  }
  
  onMouseEnter(event) {
    const card = this.element
    const rect = card.getBoundingClientRect()
    const x = event.clientX - rect.left
    const y = event.clientY - rect.top
    
    const centerX = rect.width / 2
    const centerY = rect.height / 2
    
    const rotateX = (y - centerY) / 20
    const rotateY = (centerX - x) / 20
    
    card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`
  }
  
  onMouseLeave() {
    this.element.style.transform = ''
  }
}