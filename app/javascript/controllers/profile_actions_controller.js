import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "followButton", 
    "messageModal", 
    "messageText", 
    "reportModal", 
    "reportReason", 
    "reportDetails"
  ]
  
  connect() {
    // Initialize any necessary state
  }
  
  toggleFollow(event) {
    const button = event.currentTarget;
    const profileId = button.dataset.profileId;
    const isFollowing = button.dataset.following === "true";
    
    // Toggle the following state
    button.dataset.following = !isFollowing;
    
    if (!isFollowing) {
      // Follow logic
      fetch(`/profiles/${profileId}/follow`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => {
        if (response.ok) {
          // Update button appearance for "Following" state
          button.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" class="-ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
            Following
          `;
          button.classList.remove('bg-indigo-600', 'hover:bg-indigo-700');
          button.classList.add('bg-green-600', 'hover:bg-green-700');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        button.dataset.following = "false"; // Reset if error
      });
    } else {
      // Unfollow logic
      fetch(`/profiles/${profileId}/unfollow`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin'
      })
      .then(response => {
        if (response.ok) {
          // Update button appearance for "Follow" state
          button.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" class="-ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
            </svg>
            Follow
          `;
          button.classList.remove('bg-green-600', 'hover:bg-green-700');
          button.classList.add('bg-indigo-600', 'hover:bg-indigo-700');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        button.dataset.following = "true"; // Reset if error
      });
    }
  }
  
  // Message Modal Actions
  openMessageModal() {
    this.messageModalTarget.classList.remove('hidden');
    document.body.classList.add('overflow-hidden');
  }
  
  closeMessageModal() {
    this.messageModalTarget.classList.add('hidden');
    document.body.classList.remove('overflow-hidden');
    this.messageTextTarget.value = ''; // Clear message text
  }
  
  sendMessage() {
    const messageText = this.messageTextTarget.value.trim();
    if (!messageText) {
      // Show validation error
      return;
    }
    
    const profileUsername = document.querySelector('p.text-gray-600').textContent.trim().substring(1); // Extract username from DOM
    
    // Send message via API
    fetch('/messages', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        recipient: profileUsername,
        content: messageText
      }),
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        // Show success message or notification
        this.closeMessageModal();
        
        // Create and show a toast notification
        this._showNotification('Message sent successfully', 'success');
      } else {
        throw new Error('Failed to send message');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      this._showNotification('Failed to send message. Please try again.', 'error');
    });
  }
  
  // Report Modal Actions
  openReportModal() {
    this.reportModalTarget.classList.remove('hidden');
    document.body.classList.add('overflow-hidden');
  }
  
  closeReportModal() {
    this.reportModalTarget.classList.add('hidden');
    document.body.classList.remove('overflow-hidden');
    this.reportReasonTarget.value = ''; // Reset form
    this.reportDetailsTarget.value = '';
  }
  
  submitReport() {
    const reason = this.reportReasonTarget.value;
    const details = this.reportDetailsTarget.value.trim();
    
    if (!reason) {
      // Show validation error for reason
      this._showNotification('Please select a reason for your report', 'error');
      return;
    }
    
    const profileId = document.querySelector('[data-profile-id]').dataset.profileId;
    
    // Submit report via API
    fetch('/profile_reports', {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        profile_id: profileId,
        reason: reason,
        details: details
      }),
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        this.closeReportModal();
        this._showNotification('Report submitted. Thank you for helping keep our community safe.', 'success');
      } else {
        throw new Error('Failed to submit report');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      this._showNotification('Failed to submit report. Please try again.', 'error');
    });
  }
  
  // Share Profile
  shareProfile() {
    if (navigator.share) {
      // Use Web Share API if available
      navigator.share({
        title: document.title,
        url: window.location.href
      })
      .catch(error => console.error('Error sharing:', error));
    } else {
      // Fallback: copy URL to clipboard
      const tempInput = document.createElement('input');
      document.body.appendChild(tempInput);
      tempInput.value = window.location.href;
      tempInput.select();
      document.execCommand('copy');
      document.body.removeChild(tempInput);
      
      this._showNotification('Profile URL copied to clipboard', 'success');
    }
  }
  
  // Helper to show notifications
  _showNotification(message, type = 'info') {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `fixed bottom-4 right-4 p-4 rounded-md shadow-lg flex items-center z-50 ${
      type === 'success' ? 'bg-green-50 text-green-800' : 
      type === 'error' ? 'bg-red-50 text-red-800' : 
      'bg-blue-50 text-blue-800'
    }`;
    
    // Add icon based on type
    let iconSvg = '';
    if (type === 'success') {
      iconSvg = `<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 ${type === 'success' ? 'text-green-400' : type === 'error' ? 'text-red-400' : 'text-blue-400'}" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
      </svg>`;
    } else if (type === 'error') {
      iconSvg = `<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 ${type === 'success' ? 'text-green-400' : type === 'error' ? 'text-red-400' : 'text-blue-400'}" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
      </svg>`;
    } else {
      iconSvg = `<svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 mr-2 ${type === 'success' ? 'text-green-400' : type === 'error' ? 'text-red-400' : 'text-blue-400'}" viewBox="0 0 20 20" fill="currentColor">
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
      </svg>`;
    }
    
    notification.innerHTML = `
      ${iconSvg}
      <span>${message}</span>
      <button class="ml-4 text-gray-400 hover:text-gray-500">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
        </svg>
      </button>
    `;
    
    // Add to DOM
    document.body.appendChild(notification);
    
    // Add close button event
    notification.querySelector('button').addEventListener('click', () => {
      notification.remove();
    });
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
      notification.remove();
    }, 5000);
  }
}