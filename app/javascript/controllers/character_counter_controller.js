import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "counter"]
  static values = { max: Number }
  
  connect() {
    this.count()
  }
  
  count() {
    const currentLength = this.inputTarget.value.length
    this.counterTarget.textContent = currentLength
    
    // Update counter color based on length
    if (currentLength > this.maxValue * 0.8 && currentLength <= this.maxValue * 0.95) {
      this.counterTarget.classList.add('text-yellow-600')
      this.counterTarget.classList.remove('text-red-600')
    } else if (currentLength > this.maxValue * 0.95) {
      this.counterTarget.classList.add('text-red-600')
      this.counterTarget.classList.remove('text-yellow-600')
    } else {
      this.counterTarget.classList.remove('text-yellow-600', 'text-red-600')
    }
    
    // Optional: Disable input if max is reached
    if (this.maxValue > 0 && currentLength >= this.maxValue) {
      // Prevent additional input 
      if (this.inputTarget.value.length > this.maxValue) {
        this.inputTarget.value = this.inputTarget.value.substring(0, this.maxValue)
        this.counterTarget.textContent = this.maxValue
      }
    }
  }
}