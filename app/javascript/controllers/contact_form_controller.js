import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="contact-form"
export default class extends Controller {
  static targets = ["name", "email", "phone", "issueType", "message", "terms", "success", "error", "errorMessage"];
  
  connect() {
    console.log("Contact form controller connected");
  }
  
  submit(event) {
    event.preventDefault();
    
    // Validate form
    if (!this.validateForm()) {
      return;
    }
    
    // In a real application, you would submit the form via AJAX
    // For this demo, we'll simulate a successful submission
    
    // Show success message
    this.showSuccess();
    
    // Clear form
    this.clearForm();
  }
  
  validateForm() {
    // Check required fields
    if (!this.nameTarget.value.trim()) {
      this.showError("Please enter your name.");
      return false;
    }
    
    if (!this.emailTarget.value.trim()) {
      this.showError("Please enter your email address.");
      return false;
    }
    
    if (!this.isValidEmail(this.emailTarget.value.trim())) {
      this.showError("Please enter a valid email address.");
      return false;
    }
    
    if (!this.issueTypeTarget.value) {
      this.showError("Please select an issue type.");
      return false;
    }
    
    if (!this.messageTarget.value.trim()) {
      this.showError("Please enter a message.");
      return false;
    }
    
    if (!this.termsTarget.checked) {
      this.showError("Please agree to our Privacy Policy.");
      return false;
    }
    
    return true;
  }
  
  isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }
  
  showSuccess() {
    this.successTarget.classList.remove("hidden");
    this.errorTarget.classList.add("hidden");
    
    // Hide success message after 5 seconds
    setTimeout(() => {
      this.successTarget.classList.add("hidden");
    }, 5000);
  }
  
  showError(message) {
    this.errorMessageTarget.textContent = message;
    this.errorTarget.classList.remove("hidden");
    this.successTarget.classList.add("hidden");
  }
  
  clearForm() {
    this.nameTarget.value = "";
    this.emailTarget.value = "";
    this.phoneTarget.value = "";
    this.issueTypeTarget.value = "";
    this.messageTarget.value = "";
    this.termsTarget.checked = false;
  }
}