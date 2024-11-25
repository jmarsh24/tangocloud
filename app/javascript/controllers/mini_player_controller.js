import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["progress", "volumeSlider"];

  static outlets = ["music-player"];

  static values = {
    playing: Boolean,
    muted: Boolean,
  };

  initialize() {
    this.updateProgress = this.updateProgress.bind(this);
    this._progressPercentage = 0;
    this._animationFrameRequest = null;
  }

  mute() {
    this.mutedValue = true;

    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.mute();
    }
  }

  unmute() {
    this.mutedValue = false;

    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.unmute();
    }
  }

  changeVolume() {
    const volume = this.volumeSliderTarget.value / 100;

    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.setVolume(volume);
    }
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

  changeVolume() {
    const volume = this.volumeSliderTarget.value / 100;
    this.volumeValue = volume;

    if (this.hasMusicPlayerOutlet) {
      this.musicPlayerOutlet.setVolume(volume);
    }
  }

  updateMuteState(muted) {
    this.mutedValue = muted;
  }

  updatePlayingState(playing) {
    this.playingValue = playing;
  }

  updateVolume(volume) {
    this.volumeValue = volume;

    if (this.hasVolumeSliderTarget) {
      this.volumeSliderTarget.value = volume * 100;
    }
  }
}
