import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  fill() {
    const value = this.element.dataset.suggestionValue;
    const input = document.querySelector("#tanda-recording-search");

    if (input) {
      input.value = value;
      input.form.requestSubmit();
    }
  }
}