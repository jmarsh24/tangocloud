// app/javascript/controllers/social_share_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    if (!navigator.share) {
      this.element.hidden = true;
    }
  }

  share(event) {
    navigator.share({url: this.urlValue});
  }
}