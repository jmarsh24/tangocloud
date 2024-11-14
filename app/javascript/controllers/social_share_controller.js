import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    title: String,
    text: String
  }

  connect() {
    if (!navigator.share) {
      this.element.hidden = true;
    }
  }

  share() {  
    navigator.share({
      title: this.titleValue,
      text: this.textValue,
      url: this.urlValue
    }).catch((error) => {
      console.error("Error sharing:", error);
    });
  }
}