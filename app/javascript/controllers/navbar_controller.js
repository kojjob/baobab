import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "mainNav", 
    "mobileMenu", 
    "hamburgerIcon", 
    "closeIcon", 
    "searchBar", 
    "searchSuggestions",
    "announcement"
  ]
  
  connect() {
    // Set up scroll event listener for nav transformation
    window.addEventListener("scroll", this.handleScroll.bind(this))
    
    // Initialize search box behavior
    const searchField = document.getElementById("search-field")
    if (searchField) {
      searchField.addEventListener("focus", this.showSearchSuggestions.bind(this))
      searchField.addEventListener("input", this.filterSearchSuggestions.bind(this))
    }
    
    // Add event listener for clicks outside search suggestions
    document.addEventListener("click", this.hideSearchSuggestionsIfClickedOutside.bind(this))
  }
  
  disconnect() {
    window.removeEventListener("scroll", this.handleScroll.bind(this))
    document.removeEventListener("click", this.hideSearchSuggestionsIfClickedOutside.bind(this))
  }
  
  handleScroll() {
    if (window.scrollY > 0) {
      this.mainNavTarget.classList.add("shadow-md")
      // Shrink navbar on scroll
      this.mainNavTarget.classList.add("py-2")
      this.mainNavTarget.classList.remove("py-4")
    } else {
      this.mainNavTarget.classList.remove("shadow-md")
      // Expand navbar when at top
      this.mainNavTarget.classList.remove("py-2")
      this.mainNavTarget.classList.add("py-4")
    }
  }
  
  toggleMobileMenu() {
    this.mobileMenuTarget.classList.toggle("hidden")
    this.hamburgerIconTarget.classList.toggle("hidden")
    this.closeIconTarget.classList.toggle("hidden")
    
    // Add animation classes
    if (!this.mobileMenuTarget.classList.contains("hidden")) {
      // Opening menu
      this.mobileMenuTarget.classList.add("animate-slide-in-right")
      // Prevent scrolling on body while menu is open
      document.body.classList.add("overflow-hidden")
    } else {
      // Closing menu
      this.mobileMenuTarget.classList.remove("animate-slide-in-right")
      // Re-enable scrolling
      document.body.classList.remove("overflow-hidden")
    }
  }
  
  toggleSearch() {
    this.searchBarTarget.classList.toggle("hidden")
    
    if (!this.searchBarTarget.classList.contains("hidden")) {
      // Opening search bar with animation
      this.searchBarTarget.classList.add("animate-slide-down")
      
      // Focus search input when showing search bar
      setTimeout(() => {
        document.getElementById("search-field").focus()
      }, 100)
    } else {
      // Closing search bar
      this.searchBarTarget.classList.remove("animate-slide-down")
      // Hide suggestions when hiding search bar
      this.hideSearchSuggestions()
    }
  }
  
  showSearchSuggestions() {
    if (!this.searchSuggestionsTarget.classList.contains("hidden")) return
    
    this.searchSuggestionsTarget.classList.remove("hidden")
    // Add entrance animation
    this.searchSuggestionsTarget.classList.add("animate-fade-in")
  }
  
  hideSearchSuggestions() {
    if (this.searchSuggestionsTarget.classList.contains("hidden")) return
    
    // Add exit animation
    this.searchSuggestionsTarget.classList.add("animate-fade-out")
    
    // Wait for animation to complete before hiding
    setTimeout(() => {
      this.searchSuggestionsTarget.classList.add("hidden")
      this.searchSuggestionsTarget.classList.remove("animate-fade-out")
      this.searchSuggestionsTarget.classList.remove("animate-fade-in")
    }, 150)
  }
  
  hideSearchSuggestionsIfClickedOutside(event) {
    const searchField = document.getElementById("search-field")
    const searchSuggestions = this.searchSuggestionsTarget
    
    if (searchField && searchSuggestions && 
        !searchField.contains(event.target) && 
        !searchSuggestions.contains(event.target) && 
        !searchSuggestions.classList.contains("hidden")) {
      this.hideSearchSuggestions()
    }
  }
  
  filterSearchSuggestions(event) {
    // This would typically filter suggestions based on input
    // but for demo purposes, we just show/hide based on whether there's input
    const query = event.target.value.trim()
    
    if (query.length > 0) {
      this.showSearchSuggestions()
      
      // In a real implementation, we would fetch suggestions from the server
      // and filter them based on the query
      // For demo purposes, we're just displaying the default suggestions
    } else {
      this.hideSearchSuggestions()
    }
  }
  
  hideAnnouncement() {
    // Add exit animation
    this.announcementTarget.classList.add("animate-fade-out")
    
    // Wait for animation to complete before hiding
    setTimeout(() => {
      this.announcementTarget.classList.add("hidden")
    }, 150)
  }
}