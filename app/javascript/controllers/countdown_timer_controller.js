import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["days", "hours", "minutes", "seconds"];
  static values = { targetTime: String };

  connect() {
    this.targetDate = new Date(this.targetTimeValue);
    this.updateTimer();
    this.interval = setInterval(() => this.updateTimer(), 1000);
  }

  disconnect() {
    clearInterval(this.interval);
  }

  updateTimer() {
    const now = new Date();
    const timeDifference = this.targetDate - now;

    if (timeDifference <= 0) {
      this.clearTimer();
    } else {
      const days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
      const hours = Math.floor((timeDifference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      const minutes = Math.floor((timeDifference % (1000 * 60 * 60)) / (1000 * 60));
      const seconds = Math.floor((timeDifference % (1000 * 60)) / 1000);

      this.daysTarget.textContent = String(days).padStart(2, "0");
      this.hoursTarget.textContent = String(hours).padStart(2, "0");
      this.minutesTarget.textContent = String(minutes).padStart(2, "0");
      this.secondsTarget.textContent = String(seconds).padStart(2, "0");
    }
  }

  clearTimer() {
    this.daysTarget.textContent = "00";
    this.hoursTarget.textContent = "00";
    this.minutesTarget.textContent = "00";
    this.secondsTarget.textContent = "00";
    clearInterval(this.interval);
  }
}