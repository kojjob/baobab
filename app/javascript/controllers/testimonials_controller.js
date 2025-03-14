import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]
  
  connect() {
    this.currentIndex = 0
    this.slideWidth = this.calculateSlideWidth()
    this.totalSlides = this.trackTarget.children.length
    this.visibleSlides = this.calculateVisibleSlides()
    
    window.addEventListener('resize', this.handleResize.bind(this))
    
    // Auto rotate
    this.startAutoRotate()
  }
  
  disconnect() {
    window.removeEventListener('resize', this.handleResize.bind(this))
    clearInterval(this.interval)
  }
  
  handleResize() {
    this.slideWidth = this.calculateSlideWidth()
    this.visibleSlides = this.calculateVisibleSlides()
    this.updateSlidePosition()
  }
  
  calculateSlideWidth() {
    if (window.innerWidth < 768) {
      return this.trackTarget.offsetWidth
    } else if (window.innerWidth < 1024) {
      return this.trackTarget.offsetWidth / 2
    } else {
      return this.trackTarget.offsetWidth / 3
    }
  }
  
  calculateVisibleSlides() {
    if (window.innerWidth < 768) {
      return 1
    } else if (window.innerWidth < 1024) {
      return 2
    } else {
      return 3
    }
  }
  
  startAutoRotate() {
    this.interval = setInterval(() => {
      this.next()
    }, 5000)
  }
  
  next() {
    if (this.currentIndex < this.totalSlides - this.visibleSlides) {
      this.currentIndex++
    } else {
      this.currentIndex = 0
    }
    
    this.updateSlidePosition()
  }
  
  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--
    } else {
      this.currentIndex = this.totalSlides - this.visibleSlides
    }
    
    this.updateSlidePosition()
  }
  
  updateSlidePosition() {
    const position = -this.currentIndex * this.slideWidth
    this.trackTarget.style.transform = `translateX(${position}px)`
  }
}