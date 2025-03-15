import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]
  
  connect() {
    // Setup drag and drop listeners
    if (this.hasPreviewTarget) {
      ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        this.element.addEventListener(eventName, this.preventDefaults, false)
      })
      
      this.element.addEventListener('drop', this.handleDrop.bind(this), false)
    }
  }
  
  preventDefaults(e) {
    e.preventDefault()
    e.stopPropagation()
  }
  
  triggerFileInput(e) {
    e.preventDefault()
    if (this.hasInputTarget) {
      this.inputTarget.click()
    }
  }
  
  handleDrop(e) {
    const dt = e.dataTransfer
    const files = dt.files
    
    if (this.hasInputTarget && files && files.length) {
      this.inputTarget.files = files
      this.displayPreview()
    }
  }
  
  displayPreview() {
    if (!this.hasInputTarget || !this.hasPreviewTarget) return
    
    const file = this.inputTarget.files[0]
    if (!file) return
    
    if (!file.type.match('image.*')) {
      alert('Please select an image file')
      return
    }
    
    const reader = new FileReader()
    reader.onload = (e) => {
      // Clear the preview first
      this.previewTarget.innerHTML = ''
      
      // Create and add the image
      const img = document.createElement('img')
      img.src = e.target.result
      img.classList.add('w-full', 'h-full', 'object-cover')
      this.previewTarget.appendChild(img)
    }
    
    reader.readAsDataURL(file)
  }
}