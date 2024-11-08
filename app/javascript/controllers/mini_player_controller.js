import { Controller } from "@hotwired/stimulus";
import { dispatchEvent } from "../helper";
import { installEventHandler } from "./mixins/event_handler";

export default class extends Controller {
  static targets = [
    "playButton",
    "pauseButton",
    "playingIndicator",
    "pauseIndicator",
    "progress"
  ];

  initialize() {
    installEventHandler(this);
    this.updateProgress = this.updateProgress.bind(this);
    this.handleEvent("player:progress", { with: this.updateProgress });
    this._progressPercentage = 0;
    this._animationFrameRequest = null;
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
    this.playingIndicatorTarget.classList.remove("hidden");
    this.pauseIndicatorTarget.classList.add("hidden");
  }

  #onPause() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
    this.playingIndicatorTarget.classList.add("hidden");
    this.pauseIndicatorTarget.classList.remove("hidden");
  }
}