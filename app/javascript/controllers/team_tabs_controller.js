import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="team-tabs"
export default class extends Controller {
  static targets = ["tab", "content"]
  connect() {
    // Initially show leadership tab
    this.showTab({ currentTarget: this.tabTargets.find(tab => tab.dataset.tabName === "leadership") });
  }
      
  showTab(event) {
    const tabName = event.currentTarget.dataset.tabName;
    
    // Update tab styling
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tabName === tabName) {
        tab.classList.add("border-indigo-500", "text-indigo-600");
        tab.classList.remove("border-transparent", "text-gray-500");
      } else {
        tab.classList.remove("border-indigo-500", "text-indigo-600");
        tab.classList.add("border-transparent", "text-gray-500");
      }
    });
    
    // Show selected content, hide others
    this.contentTargets.forEach(content => {
      if (content.dataset.tabName === tabName) {
        content.classList.remove("opacity-0");
        content.classList.remove("absolute");
      } else {
        content.classList.add("opacity-0");
        content.classList.add("absolute");
      }
    });
  }
}
