import { Controller } from "@hotwired/stimulus";
import WaveSurfer from "wavesurfer.js";

export default class extends Controller {
  static targets = [
    "container",
    "time",
    "duration",
    "playIcon",
    "pauseIcon",
    "hover",
  ];

  static values = {
    playing: { type: Boolean, default: false },
    audioUrl: String,
  };

  connect() {
    if (this.wavesurfer) {
      return;
    }

    this.createGradients();
    this.initializeWaveSurfer();
    this.setupEventListeners();
  }

  playPause() {
    this.wavesurfer?.playPause();
  }

  handleHover = (e) => {
    if (this.hasHoverTarget) {
      this.hoverTarget.style.width = `${e.offsetX}px`;
      this.hoverTarget.classList.remove("hidden");
    }
  };

  hideHover = () => {
    if (this.hasHoverTarget) {
      this.hoverTarget.classList.add("hidden");
    }
  };

  handleTouchStart = () => {
    // Hide the hover overlay on touch start
    this.hideHover();
  };

  playingValueChanged() {
    if (this.hasPlayIconTarget && this.hasPauseIconTarget) {
      this.playIconTarget.classList.toggle("hidden", this.playingValue);
      this.pauseIconTarget.classList.toggle("hidden", !this.playingValue);
    }
  }

  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secondsRemainder = Math.round(seconds % 60);
    return `${minutes}:${secondsRemainder.toString().padStart(2, "0")}`;
  }

  createGradients() {
    const canvasHeight = this.containerTarget.offsetHeight || 100;
    const canvas = document.createElement("canvas");
    canvas.height = canvasHeight;
    const ctx = canvas.getContext("2d");
    const heightFactor = canvasHeight * 1.35;
    const stopPosition1 = (canvasHeight * 0.7) / canvasHeight;
    const stopPosition2 = (canvasHeight * 0.7 + 1) / canvasHeight;

    this.waveGradient = ctx.createLinearGradient(0, 0, 0, heightFactor);
    this.waveGradient.addColorStop(0, "#656666");
    this.waveGradient.addColorStop(stopPosition1, "#656666");
    this.waveGradient.addColorStop(stopPosition2, "#ffffff");
    this.waveGradient.addColorStop(1, "#B1B1B1");

    this.progressGradient = ctx.createLinearGradient(0, 0, 0, heightFactor);
    this.progressGradient.addColorStop(0, "#EE772F");
    this.progressGradient.addColorStop(stopPosition1, "#EB4926");
    this.progressGradient.addColorStop(stopPosition2, "#ffffff");
    this.progressGradient.addColorStop(1, "#F6B094");
  }

  initializeWaveSurfer() {
    this.wavesurfer = WaveSurfer.create({
      container: this.containerTarget,
      waveColor: this.waveGradient,
      progressColor: this.progressGradient,
      url: this.audioUrlValue,
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
    });
  }

  setupEventListeners() {
    this.wavesurfer.on("play", this.onPlay);
    this.wavesurfer.on("pause", this.onPause);
    this.wavesurfer.on("finish", this.onFinish);
    this.wavesurfer.on("decode", this.onDecode);
    this.wavesurfer.on("timeupdate", this.onTimeUpdate);

    // Add touch event listeners
    this.containerTarget.addEventListener("touchstart", this.handleTouchStart);
  }

  disconnect() {
    this.containerTarget.removeEventListener("touchstart", this.handleTouchStart);
  }

  onPlay = () => {
    this.playingValue = true;
  };

  onPause = () => {
    this.playingValue = false;
  };

  onFinish = () => {
    this.playingValue = false;
  };

  onDecode = (duration) => {
    this.durationTarget.textContent = this.formatTime(duration);
  };

  onTimeUpdate = (currentTime) => {
    this.timeTarget.textContent = this.formatTime(currentTime);
  };
}