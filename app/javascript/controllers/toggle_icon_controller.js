import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["solidIcon", "outlineIcon"]

  toggle() {
    this.solidIconTarget.classList.toggle("hidden")
    this.outlineIconTarget.classList.toggle("hidden")
  }
}