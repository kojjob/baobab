import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template", "jsonInput", "platform", "username"]
  
  connect() {
    // Parse existing social links if any
    let existingSocialLinks = {}
    try {
      if (this.jsonInputTarget.value && this.jsonInputTarget.value !== "{}") {
        existingSocialLinks = JSON.parse(this.jsonInputTarget.value)
      }
    } catch (e) {
      console.error('Error parsing social links:', e)
    }
    
    // Create initial fields from existing data
    if (Object.keys(existingSocialLinks).length > 0) {
      // Add a field for each existing social link
      for (const [platform, username] of Object.entries(existingSocialLinks)) {
        this.addFieldWithValues(platform, username)
      }
    } else {
      // Add an empty field if no existing data
      this.addField()
    }
  }
  
  addField() {
    // Clone the template
    const content = this.templateTarget.content.cloneNode(true)
    this.containerTarget.appendChild(content)
    
    // Update the JSON after adding a new field
    this.updateJson()
  }
  
  addFieldWithValues(platform, username) {
    // Clone the template
    const content = this.templateTarget.content.cloneNode(true)
    
    // Set values before appending
    const platformSelect = content.querySelector('[data-social-links-target="platform"]')
    const usernameInput = content.querySelector('[data-social-links-target="username"]')
    
    if (platformSelect && usernameInput) {
      platformSelect.value = platform
      usernameInput.value = username
    }
    
    this.containerTarget.appendChild(content)
  }
  
  removeField(event) {
    // Get the field to remove
    const field = event.currentTarget.closest('.social-link-field')
    
    // Remove it from the DOM
    if (field) {
      field.remove()
      
      // Update the JSON after removing a field
      this.updateJson()
    }
  }
  
  updateJson() {
    const socialLinksData = {}
    
    // Get all current platform and username pairs
    const platforms = this.platformTargets
    const usernames = this.usernameTargets
    
    // Loop through all fields
    for (let i = 0; i < platforms.length; i++) {
      const platform = platforms[i].value
      const username = usernames[i].value
      
      // Only add if both platform and username are provided
      if (platform && username) {
        socialLinksData[platform] = username
      }
    }
    
    // Update the hidden input
    this.jsonInputTarget.value = JSON.stringify(socialLinksData)
  }
}
