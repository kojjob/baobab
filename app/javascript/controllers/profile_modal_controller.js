import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-modal"
export default class extends Controller {

  static targets = ['container', 'backdrop', 'panel', 'title', 'content', 'form', 'confirmButton']
  static values = {
    allowBackgroundClose: Boolean
  }
  
  connect() {
    // Make the modal accessible by the keyboard
    this.keydownHandler = this.keydown.bind(this)
    document.addEventListener('keydown', this.keydownHandler)
  }
  
  disconnect() {
    document.removeEventListener('keydown', this.keydownHandler)
  }
  
  open(event) {
    // Get data from the trigger element
    const title = event.currentTarget.dataset.modalTitleValue || 'Confirm'
    const content = event.currentTarget.dataset.modalContentValue || 'Are you sure?'
    const confirmText = event.currentTarget.dataset.modalConfirmTextValue || 'Confirm'
    const confirmUrl = event.currentTarget.dataset.modalConfirmUrlValue || ''
    const confirmMethod = event.currentTarget.dataset.modalConfirmMethodValue || 'post'
    
    // Set the modal content
    this.titleTarget.textContent = title
    this.contentTarget.textContent = content
    this.formTarget.action = confirmUrl
    this.formTarget.method = confirmMethod
    this.confirmButtonTarget.value = confirmText
    
    // Show the modal
    this.containerTarget.classList.remove('hidden')
    
    // Add top padding to the body to prevent content jump
    document.body.style.paddingRight = `${window.innerWidth - document.documentElement.clientWidth}px`
    document.body.style.overflow = 'hidden'
    
    // Focus the cancel button by default (safer option)
    this.panelTarget.querySelector('button[data-action="modal#close"]').focus()
  }
  
  close() {
    // Hide the modal
    this.containerTarget.classList.add('hidden')
    
    // Restore body styles
    document.body.style.paddingRight = ''
    document.body.style.overflow = ''
  }
  
  backgroundClose(event) {
    // Only close if background-close is allowed
    if (this.allowBackgroundCloseValue) {
      this.close()
    }
  }
  
  keydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }
}
