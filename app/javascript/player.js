import WaveSurfer from "wavesurfer.js";

export default class Player {
  constructor({ container, audioUrl, onPlay, onPause, onFinish, onDecode, onTimeUpdate, autoplay = false }) {
    this.container = container;
    this.audioUrl = audioUrl;
    this.wavesurfer = null;
    this.onPlay = onPlay;
    this.onPause = onPause;
    this.onFinish = onFinish;
    this.onDecode = onDecode;
    this.onTimeUpdate = onTimeUpdate;
    this.autoplay = autoplay;
    this.createGradients();
  }

  createGradients() {
    const canvasHeight = this.container.offsetHeight || 100;
    const canvas = document.createElement("canvas");
    canvas.height = canvasHeight;
    const ctx = canvas.getContext("2d");
    const heightFactor = canvasHeight * 1.35;
    const stopPosition1 = (canvasHeight * 0.7) / canvasHeight;
    const stopPosition2 = (canvasHeight * 0.7 + 1) / canvasHeight;

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

  initialize() {
    this.wavesurfer = WaveSurfer.create({
      container: this.container,
      waveColor: this.waveGradient,
      progressColor: this.progressGradient,
      url: this.audioUrl,
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
    });

    this.setupEventListeners();

    if (this.autoplay) {
      this.wavesurfer.on("ready", () => {
        this.play();
      });
    }
  }

  setupEventListeners() {
    this.wavesurfer.on("play", this.onPlay);
    this.wavesurfer.on("pause", this.onPause);
    this.wavesurfer.on("finish", this.onFinish);
    this.wavesurfer.on("decode", (duration) => this.onDecode(duration));
    this.wavesurfer.on("timeupdate", (currentTime) => this.onTimeUpdate(currentTime));
  }

  load(audioUrl) {
    this.audioUrl = audioUrl;
    this.wavesurfer.load(audioUrl);
  }

  play() {
    this.wavesurfer?.play();
  }

  pause() {
    this.wavesurfer?.pause();
  }

  destroy() {
    this.wavesurfer?.destroy();
  }
}