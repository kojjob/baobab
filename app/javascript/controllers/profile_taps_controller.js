import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "tabContent"]
  
  connect() {
    // Check if there's a tab parameter in the URL
    const urlParams = new URLSearchParams(window.location.search);
    const tabParam = urlParams.get('tab');
    
    if (tabParam) {
      // Find the tab with matching data-tab attribute
      const tabToActivate = this.tabTargets.find(tab => tab.dataset.tab === tabParam);
      if (tabToActivate) {
        this.showTab({ currentTarget: tabToActivate });
      }
    }
  }
  
  showTab(event) {
    const selectedTab = event.currentTarget.dataset.tab;
    
    // Update tab styling
    this.tabTargets.forEach(tab => {
      const indicator = tab.querySelector('.tab-indicator');
      if (tab.dataset.tab === selectedTab) {
        tab.classList.add('text-gray-900');
        tab.classList.remove('text-gray-500');
        indicator.classList.add('bg-indigo-500');
        indicator.classList.remove('bg-transparent');
      } else {
        tab.classList.remove('text-gray-900');
        tab.classList.add('text-gray-500');
        indicator.classList.remove('bg-indigo-500');
        indicator.classList.add('bg-transparent');
      }
    });
    
    // Show selected content, hide others
    this.tabContentTargets.forEach(content => {
      if (content.dataset.tab === selectedTab) {
        content.classList.remove('hidden');
      } else {
        content.classList.add('hidden');
      }
    });
    
    // Update URL to reflect the current tab
    const url = new URL(window.location);
    url.searchParams.set('tab', selectedTab);
    window.history.pushState({}, '', url);
  }
}