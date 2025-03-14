import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="community-modal"
export default class extends Controller {

  static targets = ["postModal"];
  
  openPostModal() {
    this.postModalTarget.classList.remove("hidden");
    document.body.classList.add("overflow-hidden");
  }
  
  closePostModal() {
    this.postModalTarget.classList.add("hidden");
    document.body.classList.remove("overflow-hidden");
  }
}