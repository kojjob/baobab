import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menuIcon", "closeIcon", "mobileMenu"]
  
  connect() {
    // Add scroll event listener for navbar background changes
    window.addEventListener('scroll', this.handleScroll.bind(this))
    this.handleScroll()
  }
  
  disconnect() {
    window.removeEventListener('scroll', this.handleScroll.bind(this))
  }
  
  toggleMobileMenu() {
    this.mobileMenuTarget.classList.toggle('hidden')
    this.menuIconTarget.classList.toggle('hidden')
    this.closeIconTarget.classList.toggle('hidden')
    
    // Prevent body scrolling when menu is open
    document.body.classList.toggle('overflow-hidden', !this.mobileMenuTarget.classList.contains('hidden'))
  }
  
  handleScroll() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop
    const navbar = this.element
    
    if (scrollTop > 10) {
      navbar.classList.add('shadow-md')
    } else {
      navbar.classList.remove('shadow-md')
    }
  }
}