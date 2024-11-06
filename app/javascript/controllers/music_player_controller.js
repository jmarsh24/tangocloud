import { Controller } from "@hotwired/stimulus";
import Player from "../player";
import { installEventHandler } from "./mixins/event_handler";
import { formatDuration } from "../helper";

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

    this.handleEvent("player:play", { with: () => this.play() });
    this.handleEvent("player:pause", { with: () => this.pause() });
  }

  connect() {
    if(this.audioUrlValue !== this.Player.audioUrl) {
      this.Player.load(this.audioUrlValue);
    }
  }

  play() {
    this.Player.play();
    this.#onPlay();
  }

  pause() {
    this.Player.pause();
    this.#onPause();
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

  #onPause() {
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
  }

  #onPlay() {
    this.playButtonTarget.classList.add("hidden");
    this.pauseButtonTarget.classList.remove("hidden");
  }
}