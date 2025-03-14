import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="mobile-footer"
export default class extends Controller {
  static targets = ["content", "icon"];
  toggle(event) {
    const button = event.currentTarget;
    const content = button.nextElementSibling;
    const icon = button.querySelector('svg');
    
    icon.classList.toggle("rotate-180");
    
    if (content.classList.contains("hidden")) {
      // Show content
      content.classList.remove("hidden");
      content.style.maxHeight = content.scrollHeight + "px";
    } else {
      // Hide content
      const startHeight = content.scrollHeight;
      content.style.maxHeight = startHeight + "px";
      
      // Force a reflow
      content.offsetHeight;
      
      content.style.maxHeight = "0px";
      // Wait for animation to finish before setting hidden
      setTimeout(() => {
        content.classList.add("hidden");
      }, 300);
    }
  }
}