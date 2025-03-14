import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  
  connect() {
    // Initialize all items to be closed
    this.contentTargets.forEach(content => {
      content.style.maxHeight = "0px"
    })
  }
  
  toggle(event) {
    // Find the specific icon and content for this accordion item
    const button = event.currentTarget
    const section = button.closest("div")
    const content = section.querySelector("[data-accordion-target='content']")
    const icon = section.querySelector("[data-accordion-target='icon']")
    
    icon.classList.toggle("rotate-180")
    
    if (content.classList.contains("hidden")) {
      // Show content
      content.classList.remove("hidden")
      
      // Set initial height to 0 and then animate to scrollHeight
      content.style.maxHeight = "0px"
      
      // Force a reflow
      content.offsetHeight
      
      // Animate to full height
      content.style.maxHeight = content.scrollHeight + "px"
    } else {
      // Hide content
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