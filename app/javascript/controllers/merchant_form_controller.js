import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "logoFile", "coverFile", "docsFile", "removeLogoField", "removeCoverField",
    "businessHoursCheckbox", "businessHoursFields"
  ]
  
  connect() {
    // Initialize business hours visibility
    this.initializeBusinessHours()
    
    // Set up file input change listeners
    this.setupFileInputListeners()
  }
  
  initializeBusinessHours() {
    if (this.hasBusinessHoursCheckboxTarget && this.hasBusinessHoursFieldsTarget) {
      this.businessHoursCheckboxTargets.forEach(checkbox => {
        const day = checkbox.dataset.day
        const fields = this.businessHoursFieldsTargets.find(f => f.dataset.day === day)
        
        if (fields) {
          fields.classList.toggle('hidden', !checkbox.checked)
        }
      })
    }
  }
  
  setupFileInputListeners() {
    if (this.hasLogoFileTarget) {
      this.logoFileTarget.addEventListener('change', () => {
        if (this.hasRemoveLogoFieldTarget) {
          this.removeLogoFieldTarget.value = "false"
        }
      })
    }
    
    if (this.hasCoverFileTarget) {
      this.coverFileTarget.addEventListener('change', () => {
        if (this.hasRemoveCoverFieldTarget) {
          this.removeCoverFieldTarget.value = "false"
        }
      })
    }
  }
  
  // Trigger file inputs via buttons
  triggerLogoFileInput() {
    this.logoFileTarget.click()
  }
  
  triggerCoverFileInput() {
    this.coverFileTarget.click()
  }
  
  triggerDocsFileInput() {
    this.docsFileTarget.click()
  }
  
  // Handle removal actions
  removeLogo() {
    if (this.hasRemoveLogoFieldTarget) {
      this.removeLogoFieldTarget.value = "true"
    }
  }
  
  removeCover() {
    if (this.hasRemoveCoverFieldTarget) {
      this.removeCoverFieldTarget.value = "true"
    }
  }
  
  removeDocument(event) {
    const documentId = event.currentTarget.dataset.documentId
    
    // Create hidden input field for document removal if it doesn't exist
    let hiddenInput = document.getElementById('remove_documents')
    if (!hiddenInput) {
      hiddenInput = document.createElement('input')
      hiddenInput.type = 'hidden'
      hiddenInput.id = 'remove_documents'
      hiddenInput.name = 'merchant[remove_documents]'
      hiddenInput.value = ''
      event.currentTarget.closest('form').appendChild(hiddenInput)
    }
    
    // Add document ID to the list
    const currentVal = hiddenInput.value
    hiddenInput.value = currentVal ? `${currentVal},${documentId}` : documentId
    
    // Hide the document in the UI
    event.currentTarget.closest('.relative').classList.add('hidden')
  }
  
  // Toggle business hours fields visibility
  toggleBusinessHours(event) {
    const day = event.currentTarget.dataset.day
    const fields = this.businessHoursFieldsTargets.find(f => f.dataset.day === day)
    
    if (fields) {
      fields.classList.toggle('hidden', !event.currentTarget.checked)
    }
  }
}