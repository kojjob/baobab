import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  
  connect() {
    // Set up event listeners for notification checkboxes
    document.getElementById('profile_email_notifications').addEventListener('change', this.updateNotificationSettings.bind(this))
    document.getElementById('profile_push_notifications').addEventListener('change', this.updateNotificationSettings.bind(this))
    
    // Initialize settings
    this.updateNotificationSettings()
  }
  
  updateNotificationSettings() {
    const settings = {
      email: document.getElementById('profile_email_notifications').checked,
      push: document.getElementById('profile_push_notifications').checked
    }
    
    // Update the hidden field with JSON settings
    this.element.value = JSON.stringify(settings)
  }
}