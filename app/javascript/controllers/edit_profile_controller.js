import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-profile"
export default class extends Controller {

  static targets = ['steps', 'step', 'form']

  connect() {
    this.setupTabNavigation()
    this.setupPasswordStrengthMeter()
    this.setupAvatarPreview()
  }

  // Tab Navigation
  setupTabNavigation() {
    const tabs = document.querySelectorAll('.tab-link')
    const tabContents = document.querySelectorAll('.tab-content')

    tabs.forEach(tab => {
      tab.addEventListener('click', (e) => {
        e.preventDefault()
        
        // Remove active states from all tabs
        tabs.forEach(t => {
          t.classList.remove('active', 'text-gray-900', 'dark:text-white', 'border-gray-900', 'dark:border-white')
          t.classList.add('text-gray-500', 'dark:text-gray-400', 'border-transparent')
        })

        // Add active state to clicked tab
        tab.classList.remove('text-gray-500', 'dark:text-gray-400', 'border-transparent')
        tab.classList.add('active', 'text-gray-900', 'dark:text-white', 'border-gray-900', 'dark:border-white')

        // Hide all tab contents
        tabContents.forEach(content => {
          content.classList.add('hidden')
        })

        // Show selected tab content
        const targetTab = tab.getAttribute('data-tab')
        document.getElementById(`${targetTab}-tab`).classList.remove('hidden')
      })
    })
  }

  // Password Strength Meter
  setupPasswordStrengthMeter() {
    const passwordInput = document.getElementById('new_password')
    const strengthMeter = document.getElementById('password-strength')

    if (passwordInput) {
      passwordInput.addEventListener('input', () => {
        const password = passwordInput.value
        const strength = this.calculatePasswordStrength(password)
        
        // Update strength meter
        strengthMeter.style.width = `${strength}%`
        strengthMeter.classList.remove('bg-red-500', 'bg-yellow-500', 'bg-green-500')
        
        if (strength < 40) {
          strengthMeter.classList.add('bg-red-500')
        } else if (strength < 70) {
          strengthMeter.classList.add('bg-yellow-500')
        } else {
          strengthMeter.classList.add('bg-green-500')
        }
      })
    }
  }

  // Password Strength Calculation
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

  // Avatar Preview
  setupAvatarPreview() {
    const avatarInput = document.querySelector('input[type="file"]')
    const avatarPreview = document.querySelector('.avatar-upload-form img')

    if (avatarInput && avatarPreview) {
      avatarInput.addEventListener('change', (e) => {
        const file = e.target.files[0]
        if (file) {
          const reader = new FileReader()
          reader.onload = (event) => {
            avatarPreview.src = event.target.result
          }
          reader.readAsDataURL(file)
        }
      })
    }
  }

  // Phone Number Formatter
  formatPhoneNumber(event) {
    let phoneNumber = event.target.value.replace(/\D/g, '')
    
    // Ghana phone number formatting
    if (phoneNumber.startsWith('0')) {
      phoneNumber = phoneNumber.slice(1)
    }
    
    if (phoneNumber.length > 9) {
      phoneNumber = phoneNumber.slice(0, 9)
    }
    
    // Format based on Ghana's phone number structure
    let formattedNumber = ''
    if (phoneNumber.length > 0) {
      formattedNumber = '+233 ' + 
        phoneNumber.slice(0, 3) + ' ' + 
        phoneNumber.slice(3, 6) + ' ' + 
        phoneNumber.slice(6)
    }
    
    event.target.value = formattedNumber
  }

  // Validate Phone Number
  validatePhoneNumber(phoneNumber) {
    // Ghana phone number regex (simplified)
    const ghanaPhoneRegex = /^\+233\s?[025]\d{2}\s?\d{3}\s?\d{4}$/
    return ghanaPhoneRegex.test(phoneNumber)
  }
}
