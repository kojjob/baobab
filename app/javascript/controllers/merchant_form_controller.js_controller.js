import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["characterCount"]
  
  connect() {
    const descriptionField = document.getElementById('merchant_description')
    if (descriptionField) {
      this.updateCharacterCount(descriptionField)
      descriptionField.addEventListener('input', (e) => this.updateCharacterCount(e.target))
    }
  }
  
  updateCharacterCount(textarea) {
    const currentLength = textarea.value.length
    const maxLength = 500
    
    if (this.hasCharacterCountTarget) {
      this.characterCountTarget.textContent = currentLength
      
      if (currentLength > maxLength) {
        this.characterCountTarget.classList.add('text-red-500')
      } else {
        this.characterCountTarget.classList.remove('text-red-500')
      }
    }
  }
}