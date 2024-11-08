import WaveSurfer from "wavesurfer.js";
import { dispatchEvent } from "./helper";

export default class Player {
  constructor({ container, audioUrl, volume = 1, muted = false, autoplay = false }) {
    this.container = container;
    this._audioUrl = audioUrl;
    this.autoplay = autoplay;
    this.volume = volume;
    this.isMuted = muted;
    this.createGradients();
    this.isReady = false;
  }

  initialize() {
    this.wavesurfer = WaveSurfer.create({
      container: this.container,
      waveColor: this.waveGradient,
      progressColor: this.progressGradient,
      url: this._audioUrl,
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
      backend: "MediaElement"
    });

    this.wavesurfer.setVolume(this.volume);

    this.wavesurfer.once("ready", () => {
      this.duration = this.wavesurfer.getDuration();
      this.isReady = true;

      dispatchEvent(document, "player:ready", { duration: this.duration });

      if (this.autoplay) {
        this.play();
      }
    });

    this.wavesurfer.on("timeupdate", (currentTime) => {
      if (this.isReady) {
        this.dispatchProgressEvent(currentTime);
      }
    });

    this.wavesurfer.on("finish", () => {
      dispatchEvent(document, "player:finish");
    });

    if (this.isMuted) {
      this.wavesurfer.setMuted(true);
    }
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

  load(audioUrl) {
    this.wavesurfer.destroy();
    this.audioUrl = audioUrl;
    this.initialize();
    dispatchEvent(document, "player:beforePlaying");
  }

  play() {
    this.wavesurfer.play();
    dispatchEvent(document, "player:playing");
  }

  pause() {
    if (this.wavesurfer.isPlaying()) {
      this.wavesurfer.pause();
      dispatchEvent(document, "player:pause");
    }
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

    const heightFactor = canvasHeight * 1.35;
    const stopPosition1 = 0.7;
    const stopPosition2 = (0.7 * canvasHeight + 1) / canvasHeight;

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