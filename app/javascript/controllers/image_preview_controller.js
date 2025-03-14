import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "dropzone", "placeholder"]

  connect() {
    // Check if we already have an image attached
    if (this.hasPreviewTarget && this.previewTarget.src) {
      this.showPreview()
    }
  }

  preview(event) {
    const input = this.inputTarget
    if (input.files && input.files[0]) {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        this.updatePreview(e.target.result)
      }
      
      reader.readAsDataURL(input.files[0])
    }
  }
  
  updatePreview(src) {
    // If we have a preview image, update its src
    if (this.hasPreviewTarget) {
      this.previewTarget.src = src
    } else {
      // Otherwise create a new image element
      const img = document.createElement('img')
      img.classList.add('w-full', 'h-full', 'object-cover')
      img.src = src
      
      // Set it as the preview target
      img.setAttribute('data-image-preview-target', 'preview')
      
      // Clear placeholder if it exists
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add('hidden')
      }
      
      // Add the image to the dropzone
      this.dropzoneTarget.appendChild(img)
    }
    
    // Hide placeholder if it exists
    if (this.hasPlaceholderTarget) {
      this.placeholderTarget.classList.add('hidden')
    }
  }
  
  // Drag and drop handling
  dragOver(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.add('drag-active')
  }
  
  dragLeave(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove('drag-active')
  }
  
  drop(event) {
    event.preventDefault()
    this.dropzoneTarget.classList.remove('drag-active')
    
    if (event.dataTransfer.files && event.dataTransfer.files[0]) {
      // Update the file input
      this.inputTarget.files = event.dataTransfer.files
      
      // Trigger preview
      this.preview()
    }
  }
}