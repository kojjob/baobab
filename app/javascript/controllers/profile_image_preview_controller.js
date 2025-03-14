import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder"]

  connect() {
    // Check if we have a preview element already
    this.checkAndShowPreview()
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
      img.setAttribute('data-image-preview-target', 'preview')
      img.src = src
      
      // Find the parent element (might be the placeholder or its parent)
      const container = this.hasPlaceholderTarget ? this.placeholderTarget.parentElement : this.element
      
      // Clear existing content
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add('hidden')
      }
      
      container.appendChild(img)
    }
  }
  
  checkAndShowPreview() {
    // If we have a preview target with a valid src, just make sure it's visible
    if (this.hasPreviewTarget && this.previewTarget.src) {
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add('hidden')
      }
    }
  }
}
