import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="events-carousel"
export default class extends Controller {
  static targets = ["carousel", "indicator"];
  
  connect() {
    console.log("Events carousel controller connected");
    
    // Update indicators on scroll
    this.carouselTarget.addEventListener("scroll", this.updateIndicators.bind(this));
  }
      
  goToSlide(event) {
    const index = event.currentTarget.dataset.index;
    const slideWidth = this.carouselTarget.children[0].offsetWidth;
    const scrollPosition = index * slideWidth;
    
    this.carouselTarget.scrollTo({
      left: scrollPosition,
      behavior: "smooth"
    });
  }
  
  updateIndicators() {
    const slideWidth = this.carouselTarget.children[0].offsetWidth;
    const scrollPosition = this.carouselTarget.scrollLeft;
    const currentIndex = Math.round(scrollPosition / slideWidth);
    
    this.indicatorTargets.forEach((indicator, index) => {
      if (index === currentIndex) {
        indicator.classList.remove("bg-gray-300");
        indicator.classList.add("bg-indigo-600");
      } else {
        indicator.classList.add("bg-gray-300");
        indicator.classList.remove("bg-indigo-600");
      }
    });
  }
}
