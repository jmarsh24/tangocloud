import { Controller } from "@hotwired/stimulus";
import { useDebounce } from "stimulus-use";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static debounces = ["submit"];

  initialize() {
    useDebounce(this);
  }

  submit() {
    const form = this.element.closest("form");
    if (form) {
      form.requestSubmit();
    }
  }
}