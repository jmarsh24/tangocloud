import { Controller } from "@hotwired/stimulus";
import { dispatchEvent } from "../helper";
import { installEventHandler } from "./mixins/event_handler";

export default class extends Controller {
  static targets = [
    "playButton",
    "pauseButton",
    "playingIndicator",
    "pauseIndicator",
    "progress",
  ];

  initialize() {
    installEventHandler(this);
    this.updateProgress = this.updateProgress.bind(this);
    this.handleEvent("player:progress", { with: this.updateProgress });
    this._progressPercentage = 0;
    this._animationFrameRequest = null;

    document.addEventListener("player:playing", this.#onPlay.bind(this));
    document.addEventListener("player:pause", this.#onPause.bind(this));
  }

  play() {
    dispatchEvent(document, "player:play");
    this.#onPlay();
  }

  pause() {
    dispatchEvent(document, "player:pause");
    this.#onPause();
  }

  updateProgress(event) {
    const { currentTime, duration } = event.detail;
    this._progressPercentage = (currentTime / duration) * 100;

    if (!this._animationFrameRequest) {
      this._animationFrameRequest = requestAnimationFrame(() => {
        this.progressTarget.style.width = `${this._progressPercentage}%`;
        this._animationFrameRequest = null;
      });
    }
  }

  #onPlay() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
    if (this.hasPlayingIndicatorTarget) {
      this.playingIndicatorTarget.classList.remove("hidden");
    }
    if (this.hasPauseIndicatorTarget) {
      this.pauseIndicatorTarget.classList.add("hidden");
    }
  }

  #onPause() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
    if (this.hasPlayingIndicatorTarget) {
      this.playingIndicatorTarget.classList.add("hidden");
    }
    if (this.hasPauseIndicatorTarget) {
      this.pauseIndicatorTarget.classList.remove("hidden");
    }
  }
}
