import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // Show the first tab by default
    this.change({ currentTarget: this.tabTargets[0] })
  }

  change(event) {
    const selectedId = event.currentTarget.dataset.id

    // Update tab states
    this.tabTargets.forEach(tab => {
      if (tab.dataset.id === selectedId) {
        tab.classList.add('border-primary-600', 'text-primary-600', 'dark:text-primary-400', 'dark:border-primary-400')
        tab.classList.remove('border-transparent', 'text-gray-500', 'dark:text-gray-400', 'hover:text-gray-700', 'dark:hover:text-gray-300')
      } else {
        tab.classList.remove('border-primary-600', 'text-primary-600', 'dark:text-primary-400', 'dark:border-primary-400')
        tab.classList.add('border-transparent', 'text-gray-500', 'dark:text-gray-400', 'hover:text-gray-700', 'dark:hover:text-gray-300')
      }
    })

    // Show the selected panel and hide others
    this.panelTargets.forEach(panel => {
      if (panel.dataset.id === selectedId) {
        panel.classList.remove('hidden')
      } else {
        panel.classList.add('hidden')
      }
    })
  }
}