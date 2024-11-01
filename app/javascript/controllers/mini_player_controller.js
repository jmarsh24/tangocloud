import { Controller } from "@hotwired/stimulus";
import { dispatchEvent } from "../helper";
import { installEventHandler } from "./mixins/event_handler";

export default class extends Controller {
  static targets = ["playButton", "pauseButton", "playingIndicator", "pauseIndicator"];

  initialize() {
    installEventHandler(this);
  }

  connect() {
    this.handleEvent("musicPlayer:play", { with: this.#setPlayingStatus.bind(this) });
    this.handleEvent("musicPlayer:pause", { with: this.#setPauseStatus.bind(this) });
  }

  play() {
    dispatchEvent(document, "musicPlayer:play");
  }

  pause() {
    dispatchEvent(document, "musicPlayer:pause");
  }

  #setPlayingStatus() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
    this.playingIndicatorTarget.classList.remove("hidden");
    this.pauseIndicatorTarget.classList.add("hidden");
  }

  #setPauseStatus() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
    this.playingIndicatorTarget.classList.add("hidden");
    this.pauseIndicatorTarget.classList.remove("hidden");
  }
}