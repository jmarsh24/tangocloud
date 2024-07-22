import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable"]

  connect() {
    console.log('Hello, Stimulus!')
  }

  toggle() {
    console.log('Toggling')
    this.toggleableTarget.classList.toggle('hidden')
  }
}
