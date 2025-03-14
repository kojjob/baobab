import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['steps', 'step', 'form']
  
  // Static values for configuration
  static values = {
    currentStep: { type: Number, default: 0 }
  }

  connect() {
    console.log('Signup form controller connected')
    this.initPasswordStrengthMeter()
    this.initPhoneNumberFormatter()
  }

  // Navigation Methods
  nextStep(event) {
    const currentStep = this.findCurrentStep()
    
    // Validate current step before proceeding
    if (!this.validateStep(currentStep)) {
      return
    }

    // Move to next step
    this.moveToStep(this.currentStepValue + 1)
  }

  previousStep(event) {
    // Move to previous step
    this.moveToStep(this.currentStepValue - 1)
  }

  moveToStep(stepIndex) {
    // Ensure step is within bounds
    if (stepIndex < 0 || stepIndex >= this.stepTargets.length) {
      return
    }

    // Hide all steps
    this.stepTargets.forEach(step => step.classList.add('hidden'))
    
    // Show target step
    this.stepTargets[stepIndex].classList.remove('hidden')
    
    // Update current step value
    this.currentStepValue = stepIndex
  }

  // Validation Methods
  validateStep(step) {
    const stepName = step.dataset.step
    
    switch(stepName) {
      case 'basic-info':
        return this.validateBasicInfo(step)
      case 'contact-info':
        return this.validateContactInfo(step)
      case 'password':
        return this.validatePassword(step)
      default:
        return true
    }
  }

  validateBasicInfo(step) {
    const firstName = step.querySelector('#user_first_name')
    const lastName = step.querySelector('#user_last_name')
    
    let isValid = true
    
    // First Name Validation
    if (!this.validateField(firstName, value => value.trim() !== '', 'First name is required')) {
      isValid = false
    }
    
    // Last Name Validation
    if (!this.validateField(lastName, value => value.trim() !== '', 'Last name is required')) {
      isValid = false
    }
    
    return isValid
  }

  validateContactInfo(step) {
    const email = step.querySelector('#user_email')
    
    // Email Validation
    return this.validateField(
      email, 
      value => this.isValidEmail(value),
      'Please enter a valid email address'
    )
  }

  validatePassword(step) {
    const password = step.querySelector('#user_password')
    const passwordConfirmation = step.querySelector('#user_password_confirmation')
    
    let isValid = true
    
    // Password Validation
    isValid = this.validateField(
      password, 
      value => value.length >= 8, 
      'Password must be at least 8 characters long'
    ) && isValid
    
    // Password Confirmation Validation
    isValid = this.validateField(
      passwordConfirmation, 
      value => value === password.value, 
      'Passwords do not match'
    ) && isValid
    
    return isValid
  }

  // Utility Validation Method
  validateField(field, validationFn, errorMessage) {
    if (!field) return true

    const isValid = validationFn(field.value)
    
    if (!isValid) {
      this.showFieldError(field, errorMessage)
      return false
    }
    
    this.clearFieldError(field)
    return true
  }

  // Error Handling Methods
  showFieldError(field, message) {
    // Remove any existing error
    this.clearFieldError(field)
    
    // Create error message element
    const errorEl = document.createElement('p')
    errorEl.classList.add(
      'text-red-500', 
      'text-xs', 
      'mt-1', 
      'field-error'
    )
    errorEl.textContent = message
    
    // Add error styling to field
    field.classList.add(
      'border-red-500', 
      'focus:ring-red-500'
    )
    
    // Insert error message after the field
    field.parentNode.insertBefore(errorEl, field.nextSibling)
  }

  clearFieldError(field) {
    // Remove error message
    const errorEl = field.parentNode.querySelector('.field-error')
    if (errorEl) {
      errorEl.remove()
    }
    
    // Remove error styling
    field.classList.remove(
      'border-red-500', 
      'focus:ring-red-500'
    )
    field.classList.add(
      'border-gray-300', 
      'focus:ring-purple-500'
    )
  }

  // Helper Methods
  findCurrentStep() {
    return this.stepTargets[this.currentStepValue]
  }

  handleSubmit(event) {
    // Perform final validation before form submission
    const isValid = this.stepTargets.every(step => 
      this.validateStep(step)
    )
    
    if (!isValid) {
      event.preventDefault()
    }
  }

  // Password Strength Meter
  initPasswordStrengthMeter() {
    const passwordInput = this.formTarget.querySelector('#user_password')
    if (!passwordInput) return

    // Create strength meter
    const strengthMeter = document.createElement('div')
    strengthMeter.classList.add(
      'mt-2', 
      'h-1', 
      'w-full', 
      'bg-gray-200', 
      'rounded-full', 
      'overflow-hidden'
    )
    
    const strengthIndicator = document.createElement('div')
    strengthIndicator.classList.add(
      'h-full', 
      'w-0', 
      'transition-all', 
      'duration-300'
    )
    strengthMeter.appendChild(strengthIndicator)
    
    passwordInput.parentNode.insertBefore(
      strengthMeter, 
      passwordInput.nextSibling
    )
    
    // Add input listener
    passwordInput.addEventListener('input', () => {
      const strength = this.calculatePasswordStrength(passwordInput.value)
      
      // Update strength meter
      strengthIndicator.style.width = `${strength}%`
      strengthIndicator.classList.remove(
        'bg-red-500', 
        'bg-yellow-500', 
        'bg-green-500'
      )
      
      if (strength < 40) {
        strengthIndicator.classList.add('bg-red-500')
      } else if (strength < 70) {
        strengthIndicator.classList.add('bg-yellow-500')
      } else {
        strengthIndicator.classList.add('bg-green-500')
      }
    })
  }

  // Phone Number Formatter
  initPhoneNumberFormatter() {
    const phoneInput = this.formTarget.querySelector('#user_phone_number')
    if (!phoneInput) return

    phoneInput.addEventListener('input', (e) => {
      e.target.value = this.formatPhoneNumber(e.target.value)
    })
  }

  // Utility Methods
  calculatePasswordStrength(password) {
    let strength = 0
    
    // Length
    if (password.length >= 8) strength += 20
    if (password.length >= 12) strength += 10
    
    // Complexity
    if (/[A-Z]/.test(password)) strength += 20  // Uppercase
    if (/[a-z]/.test(password)) strength += 20  // Lowercase
    if (/[0-9]/.test(password)) strength += 20  // Numbers
    if (/[^A-Za-z0-9]/.test(password)) strength += 10  // Special characters
    
    return Math.min(strength, 100)
  }

  formatPhoneNumber(phoneNumber) {
    // Remove all non-digit characters
    let cleaned = phoneNumber.replace(/\D/g, '')
    
    // Ghana phone number formatting
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.slice(1)
    }
    
    if (cleaned.length > 9) {
      cleaned = cleaned.slice(0, 9)
    }
    
    // Format based on Ghana's phone number structure
    if (cleaned.length > 0) {
      return '+233 ' + 
        cleaned.slice(0, 3) + ' ' + 
        cleaned.slice(3, 6) + ' ' + 
        cleaned.slice(6)
    }
    
    return cleaned
  }

  // Validation Helpers
  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email.trim())
  }

  validatePhoneNumber(phoneNumber) {
    // Ghana phone number regex (simplified)
    const ghanaPhoneRegex = /^\+233\s?[025]\d{2}\s?\d{3}\s?\d{4}$/
    return ghanaPhoneRegex.test(phoneNumber)
  }
}