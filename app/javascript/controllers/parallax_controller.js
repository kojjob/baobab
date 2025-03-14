import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["layer"]
  
  connect() {
    this.addEventListeners()
  }
  
  disconnect() {
    this.removeEventListeners()
  }
  
  addEventListeners() {
    window.addEventListener('mousemove', this.handleMouseMove.bind(this))
    window.addEventListener('deviceorientation', this.handleDeviceOrientation.bind(this))
  }
  
  removeEventListeners() {
    window.removeEventListener('mousemove', this.handleMouseMove.bind(this))
    window.removeEventListener('deviceorientation', this.handleDeviceOrientation.bind(this))
  }
  
  handleMouseMove(event) {
    const { clientX, clientY } = event
    const centerX = window.innerWidth / 2
    const centerY = window.innerHeight / 2
    const posX = (clientX - centerX) / centerX
    const posY = (clientY - centerY) / centerY
    
    this.animateLayers(posX, posY)
  }
  
  handleDeviceOrientation(event) {
    if (!event.beta || !event.gamma) return
    
    const posX = event.gamma / 45
    const posY = event.beta / 45
    
    this.animateLayers(posX, posY)
  }
  
  animateLayers(posX, posY) {
    this.layerTargets.forEach(layer => {
      const depth = layer.dataset.depth
      const translateX = posX * depth * 50
      const translateY = posY * depth * 50
      
      layer.style.transform = `translate(${translateX}px, ${translateY}px)`
    })
  }
}
