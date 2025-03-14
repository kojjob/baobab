import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "lightIcon", "darkIcon", "toggle"]
  static values = { 
    theme: String,
    default: { type: String, default: "light" }
  }

  connect() {
    // Initialize theme from local storage, system preference, or default
    this.initializeTheme()
    
    // Listen for system preference changes
    this.setupMediaQueryListeners()
    
    // Apply initial theme state to toggle if it exists
    this.updateToggleState()
  }
  
  disconnect() {
    // Clean up media query listeners
    if (this.mediaQuery) {
      this.mediaQuery.removeEventListener("change", this.handleSystemThemeChange)
    }
  }
  
  toggle() {
    const newTheme = this.themeValue === "light" ? "dark" : "light"
    this.setTheme(newTheme)
  }
  
  initializeTheme() {
    // Priority: 
    // 1. Saved user preference
    // 2. System preference
    // 3. Default
    
    const savedTheme = localStorage.getItem("theme")
    
    if (savedTheme) {
      this.setTheme(savedTheme)
    } else {
      // Check system preference
      const prefersDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches
      this.setTheme(prefersDarkMode ? "dark" : this.defaultValue)
    }
  }
  
  setupMediaQueryListeners() {
    // Listen for system theme preference changes
    this.mediaQuery = window.matchMedia("(prefers-color-scheme: dark)")
    this.handleSystemThemeChange = this.handleSystemThemeChange.bind(this)
    this.mediaQuery.addEventListener("change", this.handleSystemThemeChange)
  }
  
  handleSystemThemeChange(event) {
    // Only change theme based on system preference if user hasn't explicitly set a preference
    if (!localStorage.getItem("theme")) {
      this.setTheme(event.matches ? "dark" : "light")
    }
  }
  
  setTheme(theme) {
    // Save theme preference
    localStorage.setItem("theme", theme)
    this.themeValue = theme
    
    // Update document element with theme class
    document.documentElement.classList.toggle("dark", theme === "dark")
    
    // Apply theme classes to all themed elements
    this.applyThemeClasses(theme)
    
    // Update any theme toggle icons
    this.updateThemeIcons(theme)
    
    // Update toggle state
    this.updateToggleState()
    
    // Dispatch a custom event for other parts of the app
    document.dispatchEvent(
      new CustomEvent("themeChanged", { detail: { theme } })
    )
  }
  
  applyThemeClasses(theme) {
    document.querySelectorAll("[data-class-light], [data-class-dark]").forEach(el => {
      if (theme === "light") {
        if (el.getAttribute("data-class-light")) {
          el.classList.add(...el.getAttribute("data-class-light").split(" "))
        }
        if (el.getAttribute("data-class-dark")) {
          el.classList.remove(...el.getAttribute("data-class-dark").split(" ").filter(Boolean))
        }
      } else {
        if (el.getAttribute("data-class-dark")) {
          el.classList.add(...el.getAttribute("data-class-dark").split(" "))
        }
        if (el.getAttribute("data-class-light")) {
          el.classList.remove(...el.getAttribute("data-class-light").split(" ").filter(Boolean))
        }
      }
    })
  }
  
  updateThemeIcons(theme) {
    if (this.hasLightIconTarget && this.hasDarkIconTarget) {
      if (theme === "light") {
        this.darkIconTarget.classList.remove("hidden")
        this.lightIconTarget.classList.add("hidden")
      } else {
        this.lightIconTarget.classList.remove("hidden")
        this.darkIconTarget.classList.add("hidden")
      }
    }
  }
  
  updateToggleState() {
    if (this.hasToggleTarget) {
      const isChecked = this.themeValue === "dark"
      this.toggleTargets.forEach(toggle => {
        if (toggle.type === "checkbox") {
          toggle.checked = isChecked
        }
      })
    }
  }
}