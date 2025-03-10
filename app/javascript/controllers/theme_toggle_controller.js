import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sunIcon", "moonIcon"]
  
  connect() {
    this.initializeTheme()
  }
  
  initializeTheme() {
    const isDarkMode = localStorage.getItem('darkMode') === 'true' || 
      (localStorage.getItem('darkMode') === null && 
       window.matchMedia('(prefers-color-scheme: dark)').matches)
    
    if (isDarkMode) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }
  
  toggle() {
    const isDarkMode = document.documentElement.classList.toggle('dark')
    localStorage.setItem('darkMode', isDarkMode)
  }
}