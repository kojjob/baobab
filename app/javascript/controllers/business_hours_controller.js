import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["openTime", "closeTime"]
  static values = { day: String }
  
  connect() {
    this.updateTimeFieldsState()
  }
  
  toggleDay(event) {
    this.updateTimeFieldsState()
    
    // If checked and no times set, add default times
    if (event.target.checked) {
      if (!this.openTimeTarget.value) {
        this.openTimeTarget.value = "09:00"
      }
      if (!this.closeTimeTarget.value) {
        this.closeTimeTarget.value = "17:00"
      }
    }
  }
  
  updateTimeFieldsState() {
    const checkbox = this.element.querySelector(`input[id="${this.dayValue}_open"]`)
    const isChecked = checkbox && checkbox.checked
    
    if (this.hasOpenTimeTarget && this.hasCloseTimeTarget) {
      this.openTimeTarget.disabled = !isChecked
      this.closeTimeTarget.disabled = !isChecked
      
      if (!isChecked) {
        // Add a hidden field to ensure we get empty values in params
        const dayKey = this.dayValue.toLowerCase()
        const hiddenInput = document.createElement('input')
        hiddenInput.type = 'hidden'
        hiddenInput.name = `merchant[business_hours][${dayKey}][open]`
        hiddenInput.value = 'false'
        checkbox.parentNode.appendChild(hiddenInput)
      }
    }
  }
}