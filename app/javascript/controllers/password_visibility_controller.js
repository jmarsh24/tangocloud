import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="password-visibility"
export default class extends Controller {
  static targets = ["password", "eye", "eyeSlash"]


  toggle() {
    const newType = this.passwordTargets[0].type === "password" ? "text" : "password"
    this.setPasswordTypes(newType)
    this.toggleIcons(newType)
  }

  setPasswordTypes(type) {
    this.passwordTargets.forEach(passwordField => {
      passwordField.type = type
    })
  }

  toggleIcons(type) {
    const isPasswordVisible = type === "text"
    this.eyeTargets.forEach(eyeIcon => eyeIcon.classList.toggle("hidden", isPasswordVisible))
    this.eyeSlashTargets.forEach(eyeSlashIcon => eyeSlashIcon.classList.toggle("hidden", !isPasswordVisible))
  }
}
