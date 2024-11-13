// app/javascript/controllers/quote_cycler_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["content"];
  static values = { interval: { type: Number, default: 5000 } };

  connect() {
    this.currentIndex = 0;
    this.showCurrentContent();
    this.startCycling();
  }

  startCycling() {
    this.intervalId = setInterval(() => {
      this.cycleContent();
    }, this.intervalValue);
  }

  cycleContent() {
    this.contentTargets[this.currentIndex].classList.add("hidden");

    this.currentIndex = (this.currentIndex + 1) % this.contentTargets.length;

    this.showCurrentContent();
  }

  showCurrentContent() {
    this.contentTargets[this.currentIndex].classList.remove("hidden");
  }

  disconnect() {
    clearInterval(this.intervalId); 
  }
}