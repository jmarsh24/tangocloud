// app/javascript/controllers/music_player_controller.js

import { Controller } from "@hotwired/stimulus";
import Player from "../player";
import { installEventHandler } from "./mixins/event_handler";
import { formatDuration } from "../helper"; // Assumes you have this helper function

export default class extends Controller {
  static targets = [
    "waveform",
    "time",
    "duration",
    "playButton",
    "pauseButton",
    "hover",
    "albumArt",
    "nextButton",
  ];

  static values = {
    audioUrl: String,
  };

  initialize() {
    installEventHandler(this);

    this.Player = new Player({
      container: this.waveformTarget,
      audioUrl: this.audioUrlValue,
      autoplay: true,
    });

    this.Player.initialize();

    this.updateTime = this.updateTime.bind(this);
    this.setDuration = this.setDuration.bind(this);

    this.isTouchDevice = 'ontouchstart' in window || navigator.maxTouchPoints > 0;
  }

  connect() {
    if (this.audioUrlValue !== this.Player.audioUrl) {
      this.Player.load(this.audioUrlValue);
    }

    this.handleEvent("player:play", { with: () => this.play() });
    this.handleEvent("player:pause", { with: () => this.pause() });
    this.handleEvent("player:ready", { with: this.setDuration });
    this.handleEvent("player:progress", { with: this.updateTime });
    this.handleEvent("player:finish", { with: () => this.next() });
  }

  play() {
    this.Player.play();
    this.#onPlay();
  }

  pause() {
    this.Player.pause();
    this.#onPause();
  }

  next() {
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.form.requestSubmit();
    }
  }

  handleHover = (e) => {
    if (!this.isTouchDevice && this.hasHoverTarget) {
      this.hoverTarget.style.width = `${e.offsetX}px`;
      this.hoverTarget.classList.remove("hidden");
    }
  };

  hideHover = () => {
    if (!this.isTouchDevice && this.hasHoverTarget) {
      this.hoverTarget.classList.add("hidden");
    }
  };

  setDuration(event) {
    const { duration } = event.detail;
    if (this.hasDurationTarget) {
      this.durationTarget.textContent = formatDuration(duration);
    }
  }

  updateTime(event) {
    if (!this.Player.seeking) { 
      const { currentTime } = event.detail;
      if (this.hasTimeTarget) {
        this.timeTarget.textContent = formatDuration(currentTime);
      }
    }
  }

  #onPause() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
    if (this.hasAlbumArtTarget) {
      this.albumArtTarget.classList.remove("rotating");
    }
  }

  #onPlay() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
    if (this.hasAlbumArtTarget) {
      this.albumArtTarget.classList.add("rotating");
    }
  }
}