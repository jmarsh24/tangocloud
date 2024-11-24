import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["progress"];

  static outlets = ["music-player"];

  static values = {
    playing: Boolean,
  };

  initialize() {
    this.updateProgress = this.updateProgress.bind(this);
    this._progressPercentage = 0;
    this._animationFrameRequest = null;
  }

  play() {
    this.playingValue = true;
    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.play();
    }
  }

  pause() {
    this.playingValue = false;
    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.pause();
    }
  }

  updateProgress({ currentTime, duration }) {
    const percentage = currentTime / duration;
    if (this.hasProgressTarget) {
      this.progressTarget.value = percentage;
    }
  }

  seek(event) {
    const percentage = parseFloat(event.target.value);
    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.seekToPercentage(percentage);
    }
  }
}
