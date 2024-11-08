
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    this.isMobileDevice = /Mobi|Android/i.test(navigator.userAgent)
    this.mediaQuery = window.matchMedia("(max-width: 768px)")
    this.toggleTabNavigation()
  }

  toggleTabNavigation() {
    if (this.isMobileDevice && this.mediaQuery.matches) {
      this.element.classList.remove("hidden")
    } else {
      this.element.classList.add("hidden")
    }
  }
}