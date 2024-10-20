import { Controller } from "@hotwired/stimulus";
import WaveSurfer from "wavesurfer.js";
import RegionsPlugin from "wavesurfer.js/dist/plugins/regions.esm.js";

export default class extends Controller {
  static targets = [
    "audio",
    "container",
    "playButton",
    "markerDescription",
    "time",
    "duration",
    "playIcon",
    "pauseIcon",
    "hover",
  ];
  static values = {
    markers: { type: Array, default: [] },
    playing: { type: Boolean, default: false },
  };

  initialize() {
    requestAnimationFrame(() => {
      const canvas = document.createElement("canvas");
      canvas.height = 100;
      const ctx = canvas.getContext("2d");

      const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height * 1.35);
      gradient.addColorStop(0, "#656666");
      gradient.addColorStop((canvas.height * 0.7) / canvas.height, "#656666");
      gradient.addColorStop((canvas.height * 0.7 + 1) / canvas.height, "#ffffff");
      gradient.addColorStop((canvas.height * 0.7 + 2) / canvas.height, "#B1B1B1");
      gradient.addColorStop((canvas.height * 0.7 + 3) / canvas.height, "#B1B1B1");
      gradient.addColorStop(1, "#B1B1B1");

      const progressGradient = ctx.createLinearGradient(
        0,
        0,
        0,
        canvas.height * 1.35
      );
      progressGradient.addColorStop(0, "#EE772F");
      progressGradient.addColorStop(
        (canvas.height * 0.7) / canvas.height,
        "#EB4926"
      );
      progressGradient.addColorStop(
        (canvas.height * 0.7 + 1) / canvas.height,
        "#ffffff"
      );
      progressGradient.addColorStop(
        (canvas.height * 0.7 + 2) / canvas.height,
        "#ffffff"
      );
      progressGradient.addColorStop(
        (canvas.height * 0.7 + 3) / canvas.height,
        "#F6B094"
      );
      progressGradient.addColorStop(1, "#F6B094");

      this.wavesurfer = WaveSurfer.create({
        container: this.containerTarget,
        waveColor: gradient,
        progressColor: progressGradient,
        media: this.audioTarget,
        barWidth: 2,
        barRadius: 2,
        barGap: 1,
        hideScrollbar: true,
        backend: 'MediaElement'
      });

      this.regions = this.wavesurfer.registerPlugin(RegionsPlugin.create());

      this.wavesurfer.on("play", () => {
        this.playingValue = true;
      });

      this.wavesurfer.on("pause", () => {
        this.playingValue = false;
      });

      this.wavesurfer.on("finish", () => {
        this.playingValue = false;
      });

      this.wavesurfer.on("decode", (duration) => {
        this.durationTarget.textContent = this.formatTime(duration);
      });

      this.wavesurfer.on("timeupdate", (currentTime) => {
        this.timeTarget.textContent = this.formatTime(currentTime);
      });
    });
  }

  connect() {
  }

  handleHover = (e) => {
    this.hoverTarget.style.width = `${e.offsetX}px`;
  }

  disconnect() {
    this.wavesurfer.destroy();
    this.regions.destroy();
  }

  playPause() {
    this.wavesurfer.playPause();
  }

  playingValueChanged() {
    const playIcon = this.playIconTarget
    const pauseIcon = this.pauseIconTarget

    if (this.playingValue) {
      playIcon.classList.add('hidden');
      pauseIcon.classList.remove('hidden');
    } else {
      playIcon.classList.remove('hidden');
      pauseIcon.classList.add('hidden');
    }
  }

  markersValueChanged(markers, previousMarkers) {
    const addedMarkers = markers.filter(
      (marker) =>
        !new Set(previousMarkers.map((prevMarker) => prevMarker.time)).has(
          marker.time
        )
    );

    addedMarkers?.forEach((m) => this.#handleAddition(m));
  }

  addMarkerAtCurrentTime() {
    this.markersValue = [
      ...this.markersValue,
      {
        time: this.wavesurfer.getCurrentTime(),
        description: this.markerDescriptionTarget.value,
      },
    ];

    this.markerDescriptionTarget.value = "";
  }

  #handleAddition(value) {
    this.regions?.addRegion({
      start: value.time,
      content: value.description,
      color: "rgba(255, 0, 0, 0.5)",
      drag: false,
      resize: false,
    });
  }

  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secondsRemainder = Math.round(seconds) % 60;
    const paddedSeconds = `0${secondsRemainder}`.slice(-2);
    return `${minutes}:${paddedSeconds}`;
  }
}
