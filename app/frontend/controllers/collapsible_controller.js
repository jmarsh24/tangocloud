import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["button", "body", "icon"];
  static values = {
    expandedClass: String,
    collapsedClass: String,
  };

  toggle() {
    const expandedClasses = this.expandedClassValue.split(" ");
    const collapsedClasses = this.collapsedClassValue.split(" ");
    const isExpanded = this.bodyTarget.classList.contains(...expandedClasses);

    if (isExpanded) {
      this.bodyTarget.classList.remove(...expandedClasses);
      this.bodyTarget.classList.add(...collapsedClasses);
      this.buttonTarget.setAttribute("aria-expanded", "false");
      this.iconTarget.classList.add("rotate-180");
    } else {
      this.bodyTarget.classList.remove(...collapsedClasses);
      this.bodyTarget.classList.add(...expandedClasses);
      this.buttonTarget.setAttribute("aria-expanded", "true");
      this.iconTarget.classList.remove("rotate-180");
    }
  }
}
