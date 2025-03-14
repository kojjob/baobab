import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['section']
  static values = {
    sections: { type: Array, default: ['basic_info', 'about', 'contact', 'social', 'privacy'] }
  }

  connect() {
    console.log('Profile form controller connected')
  }

  switchSection(event) {
    const sectionId = event.currentTarget.dataset.section
    
    this.updateSectionVisibility(sectionId)
    this.updateHiddenField(sectionId)
    this.updateTabStyling(sectionId)
  }

  updateSectionVisibility(sectionId) {
    this.sectionTargets.forEach(section => {
      section.classList.toggle('hidden', section.dataset.section !== sectionId)
    })
  }

  updateHiddenField(sectionId) {
    const hiddenField = document.getElementById('section')
    if (hiddenField) {
      hiddenField.value = sectionId
    }
  }

  updateTabStyling(sectionId) {
    const tabs = document.querySelectorAll('[data-action="profile-form#switchSection"]')
    tabs.forEach(tab => {
      const isActiveTab = tab.dataset.section === sectionId
      
      tab.classList.toggle('bg-indigo-100', isActiveTab)
      tab.classList.toggle('text-indigo-700', isActiveTab)
      tab.classList.toggle('text-gray-500', !isActiveTab)
      tab.classList.toggle('hover:text-gray-700', !isActiveTab)
    })
  }

  getCurrentSectionIndex() {
    const currentSection = document.getElementById('section')?.value
    return currentSection ? this.sectionsValue.indexOf(currentSection) : -1
  }

  navigateSection(direction) {
    const currentIndex = this.getCurrentSectionIndex()
    const newIndex = direction === 'next' 
      ? Math.min(currentIndex + 1, this.sectionsValue.length - 1)
      : Math.max(currentIndex - 1, 0)

    const nextSection = this.sectionsValue[newIndex]
    
    const tabs = document.querySelectorAll('[data-action="profile-form#switchSection"]')
    tabs.forEach(tab => {
      if (tab.dataset.section === nextSection) {
        tab.click()
      }
    })
  }

  nextSection() {
    this.navigateSection('next')
  }

  previousSection() {
    this.navigateSection('previous')
  }

  suggestCompletion() {
    const incompleteSections = this.getIncompleteSections()
    
    if (incompleteSections.length > 0) {
      const firstIncompleteSection = incompleteSections[0]
      
      const tabs = document.querySelectorAll('[data-action="profile-form#switchSection"]')
      tabs.forEach(tab => {
        if (tab.dataset.section === firstIncompleteSection) {
          tab.click()
        }
      })
    }
  }

  getIncompleteSections() {
    const incompleteSections = []
    
    // Basic Info Check
    const basicInfoComplete = this.checkBasicInfoCompletion()
    if (!basicInfoComplete) incompleteSections.push('basic_info')
    
    // Bio Check
    const bioComplete = this.checkBioCompletion()
    if (!bioComplete) incompleteSections.push('about')
    
    // Contact Check
    const contactComplete = this.checkContactCompletion()
    if (!contactComplete) incompleteSections.push('contact')
    
    return incompleteSections
  }

  checkBasicInfoCompletion() {
    return !!(
      document.getElementById('profile_first_name')?.value &&
      document.getElementById('profile_last_name')?.value &&
      document.getElementById('profile_profile_username')?.value
    )
  }

  checkBioCompletion() {
    const bioField = document.getElementById('profile_profile_bio')
    return !!(bioField && bioField.value.trim())
  }

  checkContactCompletion() {
    const phoneField = document.getElementById('profile_profile_phone_number')
    return !!(phoneField && phoneField.value.trim())
  }
}