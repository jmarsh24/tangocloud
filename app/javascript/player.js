// app/javascript/player.js

import WaveSurfer from "wavesurfer.js";
import { dispatchEvent } from "./helper";

export default class Player {
  constructor({ container, audioUrl, autoplay = false }) {
    this.container = container;
    this._audioUrl = audioUrl;
    this.autoplay = autoplay;
    this.createGradients();
    this.isReady = false;
    this.isMuted = false;
    this.volume = 1;
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
      volume: this.volume,
      backend: "MediaElement"
    });

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
  }

  dispatchProgressEvent(currentTime) {
    dispatchEvent(document, "player:progress", {
      currentTime,
      duration: this.duration,
    });
  }

  get audioUrl() {
    return this._audioUrl;
  }

  set audioUrl(value) {
    this._audioUrl = value;
  }

  setVolume(value) {
    this.volume = isFinite(value) ? value : 1;
    this.wavesurfer.setVolume(this.isMuted ? 0 : this.volume);
  }

  toggleMute() {
    this.isMuted = !this.isMuted;
    this.wavesurfer.setVolume(this.isMuted ? 0 : this.volume || 1);
    dispatchEvent(document, "player:muteChange", { muted: this.isMuted });
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