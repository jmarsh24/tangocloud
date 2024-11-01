import { Controller } from "@hotwired/stimulus";
import { dispatchEvent } from "../helper";
import { installEventHandler } from "./mixins/event_handler";

export default class extends Controller {
  static targets = ["playButton", "pauseButton"];

  initialize() {
    installEventHandler(this);
  }

  connect() {
    this.handleEvent("musicPlayer:play", { with: this.#setPlayingStatus.bind(this) });
    this.handleEvent("musicPlayer:pause", { with: this.#setPauseStatus.bind(this) });
    this.handleEvent("musicPlayer:playPause", { with: this.#togglePlayPause.bind(this) });

    debugger
  }

  playPause() {
    dispatchEvent(document, "musicPlayer:playPause");
  }

  play() {
    dispatchEvent(document, "musicPlayer:play");
  }

  pause() {
    dispatchEvent(document, "musicPlayer:pause");
  }

  #togglePlayPause() {
    if (this.playButtonTarget.classList.contains("hidden")) {
      this.pause();
    } else {
      this.play();
    }
  }

  #setPlayingStatus() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
  }

  #setPauseStatus() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
  }
}