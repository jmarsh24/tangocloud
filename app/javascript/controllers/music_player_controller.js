import { Controller } from "@hotwired/stimulus";
import WaveSurfer from "wavesurfer.js";
import { formatDuration } from "../helper";

export default class extends Controller {
  static targets = [
    "waveform",
    "time",
    "duration",
    "hover",
    "albumArt",
    "nextButton",
    "previousButton",
    "progress",
    "volumeSlider",
  ];

  static outlets = ["mini-player"];

  static values = {
    audioUrl: String,
    trackTitle: String,
    detailsPrimary: String,
    detailsSecondary: String,
    waveformData: String,
    muted: Boolean,
    duration: Number,
    playing: Boolean,
  };

  initialize() {
    this.isTouchDevice =
      "ontouchstart" in window || navigator.maxTouchPoints > 0;

    this.setupWaveSurfer();
    this.loadAudio();
    this.pause();
  }

  async audioUrlValueChanged() {
    await this.loadAudio();
    this.playingValue ? this.play() : this.pause();
  }

  setupWaveSurfer() {
    if (this.wavesurfer) {
      this.wavesurfer.destroy();
    }

    this.wavesurfer = WaveSurfer.create({
      container: this.waveformTarget,
      height: 64,
      waveColor: this.createGradient("#656666", "#ffffff", "#B1B1B1"),
      progressColor: this.createGradient("#EE772F", "#EB4926", "#F6B094"),
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
      backend: "MediaElement",
    });

    if (this.mutedValue) {
      this.wavesurfer.setMuted(true);
    }

    this.updateProgress = this.updateProgress.bind(this);
    this.wavesurfer?.on("timeupdate", this.updateProgress);
    this.durationTarget.textContent = formatDuration(this.durationValue);
  }

  async loadAudio() {
    try {
      this.setupWaveSurfer();
      const waveformData = this.waveformDataValue
        ? JSON.parse(this.waveformDataValue)
        : null;

      this.wavesurfer.load(
        this.audioUrlValue,
        waveformData,
        this.durationValue
      );
      this.setupMediaSession();
    } catch (error) {
      console.error("Error loading audio:", error);
    }
  }

  setupMediaSession() {
    if ("mediaSession" in navigator) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: this.trackTitleValue,
        artist: this.detailsPrimaryValue,
        album: this.detailsSecondaryValue,
        artwork: this.hasAlbumArtTarget
          ? [{ src: this.albumArtTarget.src }]
          : [],
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
    this.playingValue = true;
    this.wavesurfer.play();
    if (this.hasAlbumArtTarget) {
      this.albumArtTarget.classList.add("rotating");
    }
  }

  pause() {
    this.playingValue = false;
    this.wavesurfer.pause();
    if (this.hasAlbumArtTarget) {
      this.albumArtTarget.classList.remove("rotating");
    }
  }

  changeVolume() {
    const volume = this.volumeSliderTarget.value / 100;
    this.wavesurfer.setVolume(volume);
  }

  mute() {
    this.wavesurfer.setMuted(true);
  }

  unmute() {
    this.wavesurfer.setMuted(false);
  }

  next() {
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.form.requestSubmit();
    }
  }

  previous() {
    if (this.hasPreviousButtonTarget) {
      this.previousButtonTarget.form.requestSubmit();
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

  setDuration() {
    if (this.hasDurationTarget) {
      this.durationTarget.textContent = formatDuration(this.wavesurfer.getDuration());
    }
  }

  updateTime(currentTime) {
    if (this.hasTimeTarget) {
      this.timeTarget.textContent = formatDuration(currentTime);
    }
  }

  seekToPercentage(percentage) {
    this.wavesurfer.seekTo(percentage);
  }

  updateProgress() {
    const currentTime = this.wavesurfer.getCurrentTime();
    
    if (this.hasMiniPlayerOutlet) {
      const duration = this.wavesurfer.getDuration();

      if (this.hasProgressTarget) {
        this.progressTarget.style.width = `${(currentTime / duration) * 100}%`;
      }
      
      this.miniPlayerOutlet.updateProgress({ currentTime, duration });
    }

    this.updateTime(currentTime);
  }

  createGradient(color1, color2, color3) {
    const canvasHeight = this.waveformTarget.offsetHeight || 100;
    const canvas = document.createElement("canvas");
    canvas.height = canvasHeight;
    const ctx = canvas.getContext("2d");

    const heightFactor = 64 * 1.35;
    const stopPosition1 = 0.675;
    const stopPosition2 = (0.675 * 77 + 1) / 77;

    const gradient = ctx.createLinearGradient(0, 0, 0, heightFactor);
    gradient.addColorStop(0, color1);
    gradient.addColorStop(stopPosition1, color1);
    gradient.addColorStop(stopPosition2, "#ffffff");
    gradient.addColorStop(1, color3);

    return gradient;
  }
}
