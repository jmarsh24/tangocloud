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
    "progress",
    "volumeSlider",
  ];

  static values = {
    audioUrl: String,
    trackTitle: String,
    detailsPrimary: String,
    detailsSecondary: String,
    waveformData: String,
    muted: Boolean,
    duration: Number,
  };

  initialize() {
    this.#onPause()
    installEventHandler(this);

    const initialVolume = (this.volumeSliderTarget.value || 100) / 100;

    this.Player = new Player({
      container: this.waveformTarget,
      volume: initialVolume,
      muted: this.mutedValue,
    });

    this.updateTime = this.updateTime.bind(this);
    this.setDuration = this.setDuration.bind(this);
    this.updateProgress = this.updateProgress.bind(this);

    this.isTouchDevice =
      "ontouchstart" in window || navigator.maxTouchPoints > 0;

    this.handleEvent("player:play", { with: () => this.play() });
    this.handleEvent("player:pause", { with: () => this.pause() });
    this.handleEvent("player:ready", { with: this.setDuration });
    this.handleEvent("player:progress", { with: this.updateTime });
    this.handleEvent("player:progress", { with: this.updateProgress });
    this.handleEvent("player:finish", { with: () => this.next() });

    this.loadAudio();
  }

  async audioUrlValueChanged() {
    await this.loadAudio();
    this.Player.play();
  }

  async loadAudio() {
    try {
      await this.Player.load(this.audioUrlValue, this.waveformDataValue, this.durationValue);
      this.updateMediaSession();
    } catch (error) {
      console.error("Error loading audio:", error);
    }
  }

  updateMediaSession() {
    if ("mediaSession" in navigator) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: this.trackTitleValue,
        artist: this.detailsPrimaryValue,
        album: this.detailsSecondaryValue,
        artwork: [{ src: this.albumArtTarget.src }],
      });

      navigator.mediaSession.setActionHandler("play", () => this.play());
      navigator.mediaSession.setActionHandler("pause", () => this.pause());
      navigator.mediaSession.setActionHandler("nexttrack", () => this.next());
      navigator.mediaSession.setActionHandler("previoustrack", () =>
        this.previous()
      );
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

  changeVolume(event) {
    const volume = event.target.value / 100;
    this.Player.setVolume(volume);
  }

  mute() {
    this.Player.mute();
  }

  unmute() {
    this.Player.unmute();
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
      const { currentTime, duration } = event.detail;
      if (this.hasTimeTarget) {
        this.timeTarget.textContent = formatDuration(currentTime);
      }
      this.updateProgress(event);
    }
  }

  updateProgress(event) {
    const { currentTime, duration } = event.detail;
    this._progressPercentage = (currentTime / duration) * 100;

    if (!this._animationFrameRequest) {
      this._animationFrameRequest = requestAnimationFrame(() => {
        if (this.hasProgressTarget) {
          this.progressTarget.style.width = `${this._progressPercentage}%`;
        }
        this._animationFrameRequest = null;
      });
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