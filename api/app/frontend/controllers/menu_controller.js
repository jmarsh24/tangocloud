import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable", "button"]

  connect() {
    console.log('Hello, Stimulus!')
    document.addEventListener('click', this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside.bind(this))
  }

  toggle() {
    console.log('Toggling')
    this.toggleableTarget.classList.toggle('hidden')
  }

  handleClickOutside(event) {
    if (!this.buttonTarget.contains(event.target) && !this.toggleableTarget.contains(event.target)) {
      this.toggleableTarget.classList.add('hidden')
    }
  }
}
