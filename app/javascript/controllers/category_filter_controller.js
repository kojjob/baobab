import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "categoryItem", "categoryGroup", "noResults"]

  connect() {
    this.filterDebounced = this.debounce(this.performFilter.bind(this), 300)
  }

  filter() {
    this.filterDebounced()
  }

  performFilter() {
    const searchTerm = this.searchInputTarget.value.toLowerCase().trim()
    
    if (searchTerm === '') {
      this.resetSearch()
      return
    }

    const matchingItems = []
    let foundAny = false

    this.categoryItemTargets.forEach(item => {
      const categoryName = item.dataset.categoryName
      const parentCategory = item.dataset.parentCategory || ''
      
      const matches = categoryName.includes(searchTerm) || parentCategory.includes(searchTerm)
      
      if (matches) {
        item.classList.remove('hidden')
        matchingItems.push(item)
        foundAny = true
      } else {
        item.classList.add('hidden')
      }
    })

    // Handle empty category groups
    this.categoryGroupTargets.forEach(group => {
      const hasVisibleItems = Array.from(group.querySelectorAll('[data-category-filter-target="categoryItem"]'))
        .some(item => !item.classList.contains('hidden'))
      
      if (hasVisibleItems) {
        group.classList.remove('hidden')
      } else {
        group.classList.add('hidden')
      }
    })

    // Show or hide the "no results" message
    if (foundAny) {
      this.noResultsTarget.classList.add('hidden')
    } else {
      this.noResultsTarget.classList.remove('hidden')
    }
  }

  resetSearch() {
    this.searchInputTarget.value = ''
    
    this.categoryItemTargets.forEach(item => {
      item.classList.remove('hidden')
    })
    
    this.categoryGroupTargets.forEach(group => {
      group.classList.remove('hidden')
    })
    
    this.noResultsTarget.classList.add('hidden')
  }

  // Utility function to debounce search input
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }
}