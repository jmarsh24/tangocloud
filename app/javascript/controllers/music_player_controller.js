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
  ];

  static values = {
    playing: { type: Boolean, default: false },
    audioUrl: String,
  };

  initialize() {
    installEventHandler(this);
  }

  connect() {
    if (this.Player) {
      return;
    }

    this.Player = new Player({
      container: this.waveformTarget,
      audioUrl: this.audioUrlValue,
      onPlay: this.onPlay.bind(this),
      onPause: this.onPause.bind(this),
      onFinish: this.onFinish.bind(this),
      onDecode: this.onDecode.bind(this),
      onTimeUpdate: this.onTimeUpdate.bind(this),
      autoplay: true,
    });

    this.Player.initialize();

    this.handleEvent("musicPlayer:play", { with: () => this.Player.play() });
    this.handleEvent("musicPlayer:pause", { with: () => this.Player.pause() });

    this.containerTarget.addEventListener("touchstart", this.handleTouchStart);
  }

  play() {
    this.Player.play();
    this.pauseButtonTarget.classList.remove("hidden");
    this.playButtonTarget.classList.add("hidden");
  }

  pause() {
    this.Player.pause();
    this.playButtonTarget.classList.remove("hidden");
    this.pauseButtonTarget.classList.add("hidden");
  }

  loadSong(song) {
    this.audioUrlValue = song.audioUrl;
    this.Player.load(song.audioUrl);
    this.updateUI(song);
  }

  updateUI(song) {
    this.albumArtTarget.src = song.albumArtUrl;
    this.timeTarget.textContent = "0:00";
    this.durationTarget.textContent = formatDuration(song.duration);
  }

  disconnect() {
    this.Player.destroy();
    this.containerTarget.removeEventListener("touchstart", this.handleTouchStart);
  }

  onPlay() {
    this.playingValue = true;
  }

  onPause() {
    this.playingValue = false;
  }

  onFinish() {
    this.playingValue = false;
  }

  onDecode(duration) {
    this.durationTarget.textContent = formatDuration(duration);
  }

  onTimeUpdate(currentTime) {
    this.timeTarget.textContent = formatDuration(currentTime);
  }

  handleTouchStart = () => {
    this.hideHover();
  };

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
}