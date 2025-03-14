import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="community-newsletter"
export default class extends Controller {
  static targets = ["email", "success"];
  connect() {
    console.log("Newsletter form controller connected");
  }
  
  submit(event) {
    event.preventDefault();
    
    const email = this.emailTarget.value.trim();
    
    // Validate email
    if (!this.isValidEmail(email)) {
      alert("Please enter a valid email address.");
      return;
    }
    
    // In a real application, you would submit the form data via AJAX
    // For this demo, we'll simulate a successful submission
    this.emailTarget.value = "";
    this.successTarget.classList.remove("hidden");
    
    // Hide success message after 5 seconds
    setTimeout(() => {
      this.successTarget.classList.add("hidden");
    }, 5000);
  }
  
  isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }
}