import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  
  connect() {
    // Set up event listeners for all privacy checkboxes
    document.getElementById('profile_profile_public').addEventListener('change', this.updatePrivacySettings.bind(this))
    document.getElementById('profile_show_location').addEventListener('change', this.updatePrivacySettings.bind(this))
    document.getElementById('profile_allow_messages').addEventListener('change', this.updatePrivacySettings.bind(this))
    document.getElementById('profile_show_activity').addEventListener('change', this.updatePrivacySettings.bind(this))
    
    // Initialize settings
    this.updatePrivacySettings()
  }
  
  updatePrivacySettings() {
    const settings = {
      public_profile: document.getElementById('profile_profile_public').checked,
      show_location: document.getElementById('profile_show_location').checked,
      allow_messages: document.getElementById('profile_allow_messages').checked,
      show_activity: document.getElementById('profile_show_activity').checked
    }
    
    // Update the hidden field with JSON settings
    this.element.value = JSON.stringify(settings)
  }
}