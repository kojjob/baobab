import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["openTime", "closeTime"]
  static values = { day: String }
  
  connect() {
    this.updateTimeFieldsState()
  }
  
  toggleDay(event) {
    this.updateTimeFieldsState()
  }
  
  updateTimeFieldsState() {
    const checkbox = this.element.querySelector(`input[id="${this.dayValue}_open"]`)
    const isChecked = checkbox && checkbox.checked
    
    if (this.hasOpenTimeTarget && this.hasCloseTimeTarget) {
      this.openTimeTarget.disabled = !isChecked
      this.closeTimeTarget.disabled = !isChecked
      
      if (!isChecked) {
        // When closed, set to empty or default values
        this.openTimeTarget.value = ""
        this.closeTimeTarget.value = ""
      } else if (!this.openTimeTarget.value && !this.closeTimeTarget.value) {
        // Set default business hours when newly checked
        this.openTimeTarget.value = "09:00"
        this.closeTimeTarget.value = "17:00"
      }
    }
  }
}