import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  
  toggle() {
    this.iconTarget.classList.toggle("rotate-180")
    
    const content = this.contentTarget
    
    if (content.classList.contains("hidden")) {
      // Show content with animation
      content.classList.remove("hidden")
      
      // Set initial height to 0 and then animate to scrollHeight
      content.style.maxHeight = "0px"
      
      // Force a reflow
      content.offsetHeight
      
      // Animate to full height
      content.style.maxHeight = content.scrollHeight + "px"
    } else {
      // Hide content with animation
      const startHeight = content.scrollHeight
      content.style.maxHeight = startHeight + "px"
      
      // Force a reflow
      content.offsetHeight
      
      // Animate to 0 height
      content.style.maxHeight = "0px"
      
      // Wait for animation to finish before setting hidden
      setTimeout(() => {
        content.classList.add("hidden")
      }, 300)
    }
  }
}