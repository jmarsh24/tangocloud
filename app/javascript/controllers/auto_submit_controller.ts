import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  submit(): void {
    (this.element as HTMLInputElement)?.form?.requestSubmit();
  }
}
