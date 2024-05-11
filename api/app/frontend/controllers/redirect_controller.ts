import { Controller } from "@hotwired/stimulus";

// This controller connects to data-controller="redirect"
export default class extends Controller {
  static values = {
    url: String,
  };

  declare readonly urlValue: string;

  visit(): void {
    window.location.href = this.urlValue;
  }
}
