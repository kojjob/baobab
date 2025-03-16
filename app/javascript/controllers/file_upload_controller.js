import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]
  
  connect() {
    // Initialize the controller
    console.log("File upload controller connected")
  }
  
  triggerFileInput(event) {
    event.preventDefault()
    this.inputTarget.click()
  }
  
  preventDefault(event) {
    event.preventDefault()
    event.stopPropagation()
  }
  
  handleDrop(event) {
    this.preventDefault(event)
    
    const dt = event.dataTransfer
    const files = dt.files
    
    if (files && files.length) {
      this.inputTarget.files = files
      this.displayPreview()
    }
  }
  
  displayPreview() {
    const file = this.inputTarget.files[0]
    if (!file) return
    
    if (!file.type.match('image.*')) {
      alert('Please select an image file')
      this.inputTarget.value = ''
      return
    }
    
    const reader = new FileReader()
    
    reader.onload = (e) => {
      // Clear the preview first
      while (this.previewTarget.firstChild) {
        this.previewTarget.removeChild(this.previewTarget.firstChild)
      }
      
      // Create and add the image
      const img = document.createElement('img')
      img.src = e.target.result
      img.classList.add('w-full', 'h-full', 'object-cover')
      this.previewTarget.appendChild(img)
    }
    
    reader.readAsDataURL(file)
  }
}