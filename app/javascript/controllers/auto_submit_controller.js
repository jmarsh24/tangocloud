import { Controller } from "@hotwired/stimulus";
import { useDebounce } from 'stimulus-use'

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static debounces = ['submit']

  initialize () {
    useDebounce(this)
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
