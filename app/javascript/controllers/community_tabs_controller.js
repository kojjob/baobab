import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="community-tabs"
export default class extends Controller {
  static targets = ["tab", "content"]
  connect() {
    console.log("Community forums controller connected");
  }
  
  showTab(event) {
    const index = event.currentTarget.dataset.index;
    
    // Update tab styling
    this.tabTargets.forEach((tab, i) => {
      if (i.toString() === index) {
        tab.classList.add("border-indigo-500", "text-indigo-600");
        tab.classList.remove("border-transparent", "text-gray-500");
      } else {
        tab.classList.remove("border-indigo-500", "text-indigo-600");
        tab.classList.add("border-transparent", "text-gray-500");
      }
    });
    
    // Show selected content, hide others
    this.contentTargets.forEach((content, i) => {
      if (i.toString() === index) {
        content.classList.remove("hidden");
      } else {
        content.classList.add("hidden");
      }
    });
  }
}