import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-action"
export default class extends Controller {

  static targets = ["copyButton", "copyMessage", "likeIcon", "likeCount", "deleteModal"];
  
  connect() {
    console.log("Post actions controller connected");
    
    // Close modal if user clicks outside of it
    document.addEventListener('click', (event) => {
      if (this.hasDeleteModalTarget && 
          !this.deleteModalTarget.classList.contains('hidden') && 
          !event.target.closest('.bg-white') && 
          !event.target.closest('[data-action="post-actions#confirmDelete"]')) {
        this.cancelDelete();
      }
    });
    
    // Allow ESC key to close the modal
    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && 
          this.hasDeleteModalTarget && 
          !this.deleteModalTarget.classList.contains('hidden')) {
        this.cancelDelete();
      }
    });
  }
  
  copyLink(event) {
    event.preventDefault();
    
    // Copy the current URL to clipboard
    navigator.clipboard.writeText(window.location.href).then(() => {
      // Show success message
      this.copyMessageTarget.classList.remove("hidden");
      setTimeout(() => {
        this.copyMessageTarget.classList.add("hidden");
      }, 2000);
    });
  }
  
  toggleLike(event) {
    event.preventDefault();
    
    // Toggle like icon fill
    if (this.likeIconTarget.getAttribute("fill") === "currentColor") {
      this.likeIconTarget.setAttribute("fill", "none");
      this.likeIconTarget.classList.remove("text-red-500");
      this.likeIconTarget.classList.add("text-gray-500");
      this.likeCountTarget.textContent = parseInt(this.likeCountTarget.textContent) - 1;
    } else {
      this.likeIconTarget.setAttribute("fill", "currentColor");
      this.likeIconTarget.classList.remove("text-gray-500");
      this.likeIconTarget.classList.add("text-red-500");
      this.likeCountTarget.textContent = parseInt(this.likeCountTarget.textContent) + 1;
    }
    
    // Here you would normally send an AJAX request to update the like status
  }
  
  confirmDelete(event) {
    // Show the delete confirmation modal
    if (this.hasDeleteModalTarget) {
      // Add a slight delay to allow any click events to resolve first
      setTimeout(() => {
        this.deleteModalTarget.classList.remove('hidden');
        
        // Prevent scrolling on the body
        document.body.style.overflow = 'hidden';
        
        // Trap focus in the modal for accessibility
        this.deleteModalTarget.querySelector('button').focus();
      }, 10);
    }
  }
  
  cancelDelete() {
    // Hide the delete confirmation modal
    if (this.hasDeleteModalTarget) {
      this.deleteModalTarget.classList.add('hidden');
      
      // Re-enable scrolling
      document.body.style.overflow = '';
    }
  }
  
  deletePost(event) {
    // The form will be submitted normally with Rails Turbo
    // This method can be used for additional client-side logic before submission
    
    // You could add a loading state here
    const submitButton = event.target;
    const originalText = submitButton.innerHTML;
    
    submitButton.disabled = true;
    submitButton.innerHTML = `
      <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      Deleting...
    `;
    
    // The form will continue submitting normally with Rails Turbo
  }
}

