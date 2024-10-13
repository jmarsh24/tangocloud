import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
export default class extends Controller {
  connect(): void {
    console.log('AutoSubmitController connected');
  }

  submit(): void {
    (this.element as HTMLInputElement)?.form?.requestSubmit();
  }
}
