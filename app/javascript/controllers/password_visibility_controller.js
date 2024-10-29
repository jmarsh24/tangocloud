import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-visibility"
export default class extends Controller {
  static targets = ["password", "eye", "eyeSlash"]
  connect() {
    console.log("Connected to password visibility controller")
  }

  toggle() {
    if (this.passwordTarget.type === "password") {
      this.passwordTarget.type = "text"
      this.eyeTarget.classList.add("hidden")
      this.eyeSlashTarget.classList.remove("hidden")
    } else {
      this.passwordTarget.type = "password"
      this.eyeTarget.classList.remove("hidden")
      this.eyeSlashTarget.classList.add("hidden")
    }
  }
}
