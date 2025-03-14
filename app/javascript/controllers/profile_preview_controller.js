import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "previewModal", "previewContent", "closeButton", "spinner"]
  static classes = ["loading"]
  static values = { 
    url: String,
    formSelector: { type: String, default: "form" }
  }
  
  connect() {
    // Create modal if it doesn't exist yet
    if (!this.hasPreviewModalTarget) {
      this.createPreviewModal()
    }
  }
  
  createPreviewModal() {
    // Create modal container
    const modal = document.createElement('div')
    modal.setAttribute('data-profile-preview-target', 'previewModal')
    modal.classList.add('fixed', 'inset-0', 'z-50', 'overflow-y-auto', 'hidden')
    modal.innerHTML = `
      <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Background overlay -->
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
        
        <!-- Modal panel -->
        <div class="inline-block align-bottom bg-white dark:bg-gray-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full">
          <!-- Modal header -->
          <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 border-b border-gray-200 dark:border-gray-600 flex justify-between items-center">
            <h3 class="text-lg leading-6 font-medium text-gray-900 dark:text-white">
              Profile Preview
            </h3>
            <button data-profile-preview-target="closeButton" type="button" class="text-gray-400 hover:text-gray-500 focus:outline-none">
              <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          
          <!-- Modal content -->
          <div data-profile-preview-target="previewContent" class="bg-white dark:bg-gray-800 px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <!-- Loading spinner -->
            <div data-profile-preview-target="spinner" class="flex justify-center py-12">
              <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-green-500"></div>
            </div>
          </div>
          
          <!-- Modal footer -->
          <div class="bg-gray-50 dark:bg-gray-700 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button type="button" data-profile-preview-target="closeButton" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 dark:border-gray-600 shadow-sm px-4 py-2 bg-white dark:bg-gray-800 text-base font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
              Close
            </button>
          </div>
        </div>
      </div>
    `
    
    document.body.appendChild(modal)
    
    // Add event listeners for close buttons
    this.closeButtonTargets.forEach(button => {
      button.addEventListener('click', () => this.hideModal())
    })
    
    // Also close on click outside the modal
    modal.addEventListener('click', (event) => {
      if (event.target === modal) {
        this.hideModal()
      }
    })
    
    // Close on ESC key
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && !modal.classList.contains('hidden')) {
        this.hideModal()
      }
    })
  }
  
  show(event) {
    event.preventDefault()
    
    // Get the form
    const form = this.element.closest(this.formSelectorValue)
    if (!form) {
      console.error('Could not find form element')
      return
    }
    
    // Show modal with spinner
    this.showModal()
    this.spinnerTarget.classList.remove('hidden')
    
    // Create FormData object
    const formData = new FormData(form)
    formData.append('preview', 'true') // Add indicator that this is a preview request
    
    // Determine the URL for the preview
    let url = this.urlValue
    if (!url) {
      // Use form action or fallback to /profiles/preview
      url = form.action ? form.action + '/preview' : '/profiles/preview'
    }
    
    // Submit the form data to the server
    fetch(url, {
      method: 'POST',
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.getCSRFToken()
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error(`Server responded with ${response.status}: ${response.statusText}`)
      }
      return response.text()
    })
    .then(html => {
      // Update the preview content
      this.previewContentTarget.innerHTML = html
      this.spinnerTarget.classList.add('hidden')
    })
    .catch(error => {
      console.error('Error generating preview:', error)
      this.previewContentTarget.innerHTML = `
        <div class="bg-red-50 dark:bg-red-900/20 border-l-4 border-red-500 p-4">
          <div class="flex">
            <div class="flex-shrink-0">
              <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
              </svg>
            </div>
            <div class="ml-3">
              <h3 class="text-sm font-medium text-red-800 dark:text-red-200">
                Error generating preview
              </h3>
              <div class="mt-2 text-sm text-red-700 dark:text-red-300">
                <p>There was an error generating your profile preview. Please try again later.</p>
                <p class="mt-1 text-xs">${error.message}</p>
              </div>
            </div>
          </div>
        </div>
      `
      this.spinnerTarget.classList.add('hidden')
    })
  }
  
  showModal() {
    // Show modal and add animation classes
    this.previewModalTarget.classList.remove('hidden')
    document.body.classList.add('overflow-hidden') // Prevent scrolling
    
    // Reset content to show spinner
    this.previewContentTarget.innerHTML = `
      <div class="flex justify-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-green-500"></div>
      </div>
    `
  }
  
  hideModal() {
    this.previewModalTarget.classList.add('hidden')
    document.body.classList.remove('overflow-hidden')
  }
  
  getCSRFToken() {
    const token = document.querySelector('meta[name="csrf-token"]')
    return token ? token.content : ''
  }
}