import { Controller } from "@hotwired/stimulus";
import { useDebounce } from 'stimulus-use';

// Connects to data-controller="search"
export default class extends Controller {
  static debounces = ['submit'];
  static values = { searchPath: String };

  initialize() {
    useDebounce(this);
  }

  focus(event) {
    if (window.location.pathname !== this.searchPathValue) {
      event.preventDefault();
      Turbo.visit(this.searchPathValue);
    } else {
      event.target.focus();
    }
  }

  submit() {
    const currentValue = this.element.value.trim();

    if (currentValue.length === 0 || currentValue === this.lastValue) {
      return;
    }

    this.lastValue = currentValue;
    this.element.form.requestSubmit();
  }
}