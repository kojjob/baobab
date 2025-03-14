import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["element", "section", "fadeIn", "slideUp", "parallax"]
  static values = {
    threshold: { type: Number, default: 0.1 },
    delay: { type: Number, default: 0 },
    root: { type: String, default: null }
  }

  connect() {
    this.setupIntersectionObserver()
    this.setupScrollEffects()
    this.applyInitialAnimations()
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
    
    // Clean up any scroll listeners
    window.removeEventListener('scroll', this.handleScroll)
  }
  
  setupIntersectionObserver() {
    // Create the observer options
    const options = {
      root: this.rootValue ? document.querySelector(this.rootValue) : null,
      rootMargin: '0px',
      threshold: this.thresholdValue
    }
    
    // Create the observer
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.animateElement(entry.target)
          
          // Unobserve after animating if not repeatable
          if (!entry.target.dataset.repeat) {
            this.observer.unobserve(entry.target)
          }
        } else if (entry.target.dataset.repeat) {
          // Reset animation when element leaves viewport if repeatable
          this.resetElement(entry.target)
        }
      })
    }, options)
    
    // Observe all element targets
    if (this.hasElementTarget) {
      this.elementTargets.forEach(element => {
        this.observer.observe(element)
      })
    }
    
    // Observe section targets with specific animation
    if (this.hasSectionTarget) {
      this.sectionTargets.forEach(section => {
        this.observer.observe(section)
      })
    }
    
    // Observe fade-in targets
    if (this.hasFadeInTarget) {
      this.fadeInTargets.forEach(element => {
        this.observer.observe(element)
      })
    }
    
    // Observe slide-up targets
    if (this.hasSlideUpTarget) {
      this.slideUpTargets.forEach(element => {
        this.observer.observe(element)
      })
    }
  }
  
  setupScrollEffects() {
    // Handle parallax scrolling
    if (this.hasParallaxTarget) {
      this.handleScroll = this.handleScroll.bind(this)
      window.addEventListener('scroll', this.handleScroll)
      // Initialize parallax positions
      this.handleScroll()
    }
  }
  
  handleScroll() {
    // Apply parallax effect to parallax targets
    if (this.hasParallaxTarget) {
      const scrollPosition = window.pageYOffset
      
      this.parallaxTargets.forEach(element => {
        const speed = element.dataset.speed || 0.5
        const yPos = -scrollPosition * speed
        element.style.transform = `translate3d(0, ${yPos}px, 0)`
      })
    }
  }
  
  applyInitialAnimations() {
    // Apply immediate animations to elements with data-immediate attribute
    document.querySelectorAll('[data-immediate]').forEach(element => {
      setTimeout(() => {
        this.animateElement(element)
      }, element.dataset.delay || 0)
    })
  }
  
  animateElement(element) {
    // Get animation type
    const animationType = element.dataset.animation || 'fade-in'
    
    // Apply the appropriate animation class based on type
    switch (animationType) {
      case 'fade-in':
        element.classList.add('animate-fade-in')
        break
      case 'slide-up':
        element.classList.add('animate-slide-up')
        break
      case 'slide-right':
        element.classList.add('animate-slide-right')
        break
      case 'slide-left':
        element.classList.add('animate-slide-left')
        break
      case 'zoom-in':
        element.classList.add('animate-zoom-in')
        break
      case 'bounce':
        element.classList.add('animate-bounce')
        break
      case 'pulse':
        element.classList.add('animate-pulse')
        break
      case 'spin':
        element.classList.add('animate-spin')
        break
      default:
        // Apply a custom animation class matching the animation type
        element.classList.add(`animate-${animationType}`)
    }
    
    // Remove opacity-0 if present (used to hide elements before animation)
    element.classList.remove('opacity-0')
    
    // Add proper visible class
    element.classList.add('opacity-100')
    
    // Remove any transform classes used to position elements before animation
    element.classList.remove('translate-y-8', 'translate-x-8', 'translate-x-negative-8', 'scale-95')
    
    // Add delay if specified
    const delay = element.dataset.delay
    if (delay) {
      element.style.animationDelay = `${delay}ms`
    }
    
    // Add duration if specified
    const duration = element.dataset.duration
    if (duration) {
      element.style.animationDuration = `${duration}ms`
    }
    
    // Fire event after animation is complete
    element.addEventListener('animationend', () => {
      // Dispatch custom event
      element.dispatchEvent(new CustomEvent('animation:complete', { bubbles: true }))
      
      // Remove animation classes if not permanent
      if (!element.dataset.permanent) {
        element.classList.remove(
          'animate-fade-in', 
          'animate-slide-up', 
          'animate-slide-right', 
          'animate-slide-left',
          'animate-zoom-in',
          'animate-bounce',
          'animate-pulse',
          'animate-spin'
        )
      }
    }, { once: true })
  }
  
  resetElement(element) {
    // Reset animation by removing animation classes
    element.classList.remove(
      'animate-fade-in', 
      'animate-slide-up', 
      'animate-slide-right', 
      'animate-slide-left',
      'animate-zoom-in',
      'animate-bounce',
      'animate-pulse',
      'animate-spin',
      'opacity-100'
    )
    
    // Add back initial state classes
    if (element.dataset.hideBefore === 'true') {
      element.classList.add('opacity-0')
    }
    
    // Reset transforms based on animation type
    const animationType = element.dataset.animation || 'fade-in'
    if (animationType === 'slide-up') {
      element.classList.add('translate-y-8')
    } else if (animationType === 'slide-right') {
      element.classList.add('translate-x-negative-8')
    } else if (animationType === 'slide-left') {
      element.classList.add('translate-x-8')
    } else if (animationType === 'zoom-in') {
      element.classList.add('scale-95')
    }
  }
  
  // Actions for specific animation triggers
  fadeIn(event) {
    this.animateElement(event.currentTarget)
  }
  
  slideUp(event) {
    const element = event.currentTarget
    element.dataset.animation = 'slide-up'
    this.animateElement(element)
  }
  
  pulse(event) {
    const element = event.currentTarget
    element.dataset.animation = 'pulse'
    this.animateElement(element)
  }
  
  bounce(event) {
    const element = event.currentTarget
    element.dataset.animation = 'bounce'
    this.animateElement(element)
  }
}