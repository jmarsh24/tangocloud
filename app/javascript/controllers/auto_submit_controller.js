import { Controller } from "@hotwired/stimulus";
import { useDebounce } from 'stimulus-use'

// Connects to data-controller="auto-submit"
export default class extends Controller {
  static debounces = ['submit']

  initialize () {
    useDebounce(this)
  }

  submit() {
    this.element.form.requestSubmit();
  }
}
