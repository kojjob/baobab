import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "success", "error", "errorMessage"]
  
  connect() {
    console.log("Newsletter controller connected")
  }
  
  submit(event) {
    event.preventDefault()
    
    const email = this.emailTarget.value.trim()
    
    // Validate email
    if (!this.isValidEmail(email)) {
      this.errorMessageTarget.textContent = "Please enter a valid email address."
      this.showError()
      return
    }
    
    // In a real implementation, this would be a fetch request to the server
    // For demonstration purposes, we'll simulate a successful submission
    this.simulateSubmission(email)
  }
  
  simulateSubmission(email) {
    // Show loading state
    const submitButton = this.element.querySelector("button[type='submit']")
    const originalText = submitButton.textContent
    submitButton.textContent = "Subscribing..."
    submitButton.disabled = true
    
    // Simulate network request with timeout
    setTimeout(() => {
      // 90% chance of success for demo purposes
      if (Math.random() < 0.9) {
        this.showSuccess()
      } else {
        this.errorMessageTarget.textContent = "There was an error. Please try again."
        this.showError()
      }
      
      // Reset button
      submitButton.textContent = originalText
      submitButton.disabled = false
    }, 1000)
  }
  
  showSuccess() {
    this.emailTarget.value = ""
    this.successTarget.classList.remove("hidden")
    this.errorTarget.classList.add("hidden")
    
    // Add entrance animation
    this.successTarget.classList.add("animate-fade-in")
    
    // Hide success message after 5 seconds
    setTimeout(() => {
      // Add exit animation
      this.successTarget.classList.add("animate-fade-out")
      
      setTimeout(() => {
        this.successTarget.classList.add("hidden")
        this.successTarget.classList.remove("animate-fade-out")
        this.successTarget.classList.remove("animate-fade-in")
      }, 150)
    }, 5000)
  }
  
  showError() {
    this.errorTarget.classList.remove("hidden")
    this.successTarget.classList.add("hidden")
    
    // Add entrance animation
    this.errorTarget.classList.add("animate-fade-in")
    
    // Hide error message after 5 seconds
    setTimeout(() => {
      // Add exit animation
      this.errorTarget.classList.add("animate-fade-out")
      
      setTimeout(() => {
        this.errorTarget.classList.add("hidden")
        this.errorTarget.classList.remove("animate-fade-out")
        this.errorTarget.classList.remove("animate-fade-in")
      }, 150)
    }, 5000)
  }
  
  isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return re.test(email)
  }
}