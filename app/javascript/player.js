import WaveSurfer from "wavesurfer.js";
import { dispatchEvent } from "./helper";

export default class Player {
  constructor({ container, volume = 1, muted = false }) {
    this.container = container;
    this.volume = volume;
    this.isMuted = muted;
    this.createGradients();
    this.isReady = false;
    this.duration = 0;
    this.initialize();
  }

  initialize() {
    this.wavesurfer = WaveSurfer.create({
      container: this.container,
      height: 64,
      waveColor: this.waveGradient,
      progressColor: this.progressGradient,
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
      backend: "MediaElement",
    });

    this.wavesurfer.setVolume(this.volume);

    this.setupEventListeners();

    if (this.isMuted) {
      this.wavesurfer.setMuted(true);
    }
  }

  setupEventListeners() {
    this.wavesurfer.on("ready", () => {
      this.duration = this.wavesurfer.getDuration();
      this.isReady = true;
      dispatchEvent(document, "player:ready", { duration: this.duration });
    });

    this.wavesurfer.on("timeupdate", (currentTime) => {
      this.dispatchProgressEvent(currentTime);
    });

    this.wavesurfer.on("finish", () => {
      dispatchEvent(document, "player:finish");
    });

    this.wavesurfer.on("error", (error) => {
      console.error("WaveSurfer error:", error);
      dispatchEvent(document, "player:error", { error });
    });
  }

  async load(audioUrl, peaks, duration) {
    try {
      this.wavesurfer.destroy();
      this.initialize();

      if (peaks) {
        this.wavesurfer.load(audioUrl, peaks, duration);
      } else {
        this.wavesurfer.load(audioUrl, null, duration);
      }
    } catch (error) {
      console.error("Error loading audio:", error);
      throw error;
    }
  }

  play() {
    this.wavesurfer.play();
    dispatchEvent(document, "player:playing");
  }

  pause() {
    this.wavesurfer.pause();
    dispatchEvent(document, "player:paused");
  }

  setVolume(value) {
    this.volume = isFinite(value) ? value : 1;
    this.wavesurfer.setVolume(this.volume);
  }

  mute() {
    if (!this.isMuted) {
      this.isMuted = true;
      this.wavesurfer.setMuted(true);
      dispatchEvent(document, "player:muteChange", { muted: true });
    }
  }

  unmute() {
    if (this.isMuted) {
      this.isMuted = false;
      this.wavesurfer.setMuted(false);
      dispatchEvent(document, "player:muteChange", { muted: false });
    }
  }

  destroy() {
    this.wavesurfer.destroy();
  }

  dispatchProgressEvent(currentTime) {
    dispatchEvent(document, "player:progress", {
      currentTime,
      duration: this.duration,
    });
  }

  createGradients() {
    const canvasHeight = this.container.offsetHeight || 100;
    const canvas = document.createElement("canvas");
    canvas.height = canvasHeight;
    const ctx = canvas.getContext("2d");

    const heightFactor = 64 * 1.35;
    const stopPosition1 = 0.675;
    const stopPosition2 = (0.675 * 77 + 1) / 77;

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
}
