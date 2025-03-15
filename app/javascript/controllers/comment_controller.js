import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment"
export default class extends Controller {

  static targets = ["content", "form", "list", "error"];
  
  connect() {
    console.log("Comments controller connected");
    
    // Set up form to work with Turbo
    if (this.hasFormTarget) {
      this.formTarget.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this));
    }
  }
  
  submit(event) {
    // Client-side validation before letting Turbo handle the form submission
    if (!this.validateForm()) {
      event.preventDefault();
      
      // Show error message
      if (document.getElementById('comment-error')) {
        document.getElementById('comment-error').classList.remove('hidden');
      }
      return false;
    }
    
    // Hide error message if it was previously shown
    if (document.getElementById('comment-error')) {
      document.getElementById('comment-error').classList.add('hidden');
    }
    
    // Let Turbo handle the form submission from here
    // The server will respond with Turbo Stream instructions
    // to append the new comment to the comments list
  }
  
  validateForm() {
    // Simple validation to ensure comment isn't empty
    if (this.hasContentTarget && this.contentTarget.value.trim() === "") {
      // Highlight the content field with an error state
      this.contentTarget.classList.add("border", "border-red-500");
      this.contentTarget.classList.remove("focus:ring-indigo-500");
      this.contentTarget.classList.add("focus:ring-red-500");
      return false;
    }
    return true;
  }
  
  handleSubmitEnd(event) {
    // This runs after Turbo has processed the server response
    // Turbo Streams automatically updates the comments list based on the server response
    
    if (event.detail.success) {
      // Additional UI updates or actions after successful submission
      this.resetForm();
      
      // Scroll to the new comment if needed
      if (this.hasListTarget && this.listTarget.firstElementChild) {
        this.listTarget.firstElementChild.scrollIntoView({ behavior: 'smooth' });
      }
    } else {
      // Handle server errors
      console.error("Error submitting comment:", event.detail.fetchResponse);
      
      // You could display a server error message here
      if (document.getElementById('comment-error')) {
        document.getElementById('comment-error').textContent = "There was an error posting your comment. Please try again.";
        document.getElementById('comment-error').classList.remove('hidden');
      }
    }
  }
  
  resetForm() {
    if (this.hasFormTarget) {
      this.formTarget.reset();
      
      // Remove any error styling
      if (this.hasContentTarget) {
        this.contentTarget.classList.remove("border", "border-red-500", "focus:ring-red-500");
        this.contentTarget.classList.add("focus:ring-indigo-500");
      }
      
      // Hide error message
      if (document.getElementById('comment-error')) {
        document.getElementById('comment-error').classList.add('hidden');
      }
    }
  }
  
  likeComment(event) {
    const commentId = event.currentTarget.dataset.commentId;
    
    // In a real app, you'd send a fetch/AJAX request to like the comment
    fetch(`/comments/${commentId}/like`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content,
        'Content-Type': 'application/json',
        'Accept': 'text/vnd.turbo-stream.html'
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        // Turbo will handle the response automatically
        // We can add visual feedback before the server responds
        const button = event.currentTarget;
        const icon = button.querySelector('svg');
        
        // Toggle like appearance temporarily
        icon.setAttribute('fill', icon.getAttribute('fill') === 'none' ? 'currentColor' : 'none');
        button.classList.toggle('text-indigo-600');
      }
    })
    .catch(error => console.error('Error liking comment:', error));
  }
  
  replyToComment(event) {
    const commentId = event.currentTarget.dataset.commentId;
    
    // Focus on comment form and update it to indicate replying
    if (this.hasContentTarget) {
      this.contentTarget.focus();
      
      // Optionally, you could update a hidden field to track the parent comment ID
      // or prefix the comment text with @username
      const replyingTo = event.currentTarget.closest('.flex').querySelector('h4').textContent;
      this.contentTarget.placeholder = `Replying to ${replyingTo}...`;
      
      // Add a hidden field for parent_id if needed
      let parentIdField = this.formTarget.querySelector('input[name="comment[parent_id]"]');
      if (!parentIdField) {
        parentIdField = document.createElement('input');
        parentIdField.type = 'hidden';
        parentIdField.name = 'comment[parent_id]';
        this.formTarget.appendChild(parentIdField);
      }
      parentIdField.value = commentId;
    }
  }
}
