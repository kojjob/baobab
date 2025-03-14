import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    debounceTime: { type: Number, default: 300 }
  }
  
  initialize() {
    this.debounce = this.debounce.bind(this)
  }
  
  debounceSearch(event) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.debounceTimeValue)
  }
  
  debounce(func, wait = this.debounceTimeValue) {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(func, wait)
  }
}