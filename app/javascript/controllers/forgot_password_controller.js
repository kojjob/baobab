import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="forgot-password"
export default class extends Controller {

  static targets = ['form', 'emailInput']

  connect() {
    console.log('Forgot password controller connected')
    this.setupEmailValidation()
  }

  setupEmailValidation() {
    this.emailInputTarget.addEventListener('input', () => {
      this.validateEmail()
    })

    this.emailInputTarget.addEventListener('blur', () => {
      this.validateEmail()
    })
  }

  validateEmail() {
    const email = this.emailInputTarget.value.trim()
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    
    if (!email) {
      this.showValidationError('Email is required')
      return false
    }

    if (!emailRegex.test(email)) {
      this.showValidationError('Please enter a valid email address')
      return false
    }

    this.clearValidationError()
    return true
  }

  handleSubmit(event) {
    if (!this.validateEmail()) {
      event.preventDefault()
    }
  }

  showValidationError(message) {
    // Remove existing error
    this.clearValidationError()
    
    // Create error element
    const errorEl = document.createElement('p')
    errorEl.classList.add(
      'text-red-500', 
      'text-xs', 
      'mt-2', 
      'email-error'
    )
    errorEl.textContent = message
    
    // Add error styling to input
    this.emailInputTarget.classList.add(
      'border-red-500', 
      'focus:ring-red-500'
    )
    
    // Insert error message
    this.emailInputTarget.parentNode.insertBefore(
      errorEl, 
      this.emailInputTarget.nextSibling
    )
  }

  clearValidationError() {
    // Remove error message
    const errorEl = this.emailInputTarget.parentNode.querySelector('.email-error')
    if (errorEl) {
      errorEl.remove()
    }
    
    // Remove error styling
    this.emailInputTarget.classList.remove(
      'border-red-500', 
      'focus:ring-red-500'
    )
  }
}
