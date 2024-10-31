import { dispatchEvent } from './helper';
import Playlist from './queue';
import WaveSurfer from 'wavesurfer.js';

class Player {
  currentSong = {};
  isPlaying = false;
  playlist = new Playlist();
  waveSurfer = null;

  constructor() {
    this.initializeWaveSurfer();
  }

  initializeWaveSurfer() {
    this.waveSurfer = WaveSurfer.create({
      container: '#waveform',
      waveColor: '#656666',
      progressColor: '#EE772F',
      barWidth: 2,
      barRadius: 2,
      barGap: 1,
      responsive: true,
      height: 100,
    });

    this.setupEventListeners();
  }

  setupEventListeners() {
    this.waveSurfer.on('play', () => {
      dispatchEvent(document, 'player:playing');
      this.isPlaying = true;
    });
    this.waveSurfer.on('pause', () => {
      dispatchEvent(document, 'player:pause');
      this.isPlaying = false;
    });
    this.waveSurfer.on('finish', () => {
      dispatchEvent(document, 'player:end');
      this.isPlaying = false;
      this.next();
    });
    this.waveSurfer.on('ready', () => {
      dispatchEvent(document, 'player:ready');
    });
  }

  playOn(index) {
    if (this.playlist.length === 0) return;

    dispatchEvent(document, 'player:beforePlaying');

    const song = this.playlist.songs[index];
    this.currentSong = song;
    this.isPlaying = true;

    if (!this.waveSurfer) {
      this.initializeWaveSurfer();
    }

    this.waveSurfer.load(song.url);

    this.waveSurfer.on('ready', () => {
      this.waveSurfer.play();
    });
  }

  play() {
    if (!this.waveSurfer) return;
    this.isPlaying = true;
    this.waveSurfer.play();
  }

  pause() {
    if (!this.waveSurfer) return;
    this.isPlaying = false;
    this.waveSurfer.pause();
  }

  stop() {
    if (!this.waveSurfer) return;
    this.isPlaying = false;
    this.waveSurfer.stop();
    this.currentSong = {};
  }

  next() {
    this.skipTo(this.currentIndex + 1);
  }

  previous() {
    this.skipTo(this.currentIndex - 1);
  }

  skipTo(index) {
    if (!this.waveSurfer) return;
    this.waveSurfer.stop();

    if (index >= this.playlist.length) {
      index = 0;
    } else if (index < 0) {
      index = this.playlist.length - 1;
    }

    this.playOn(index);
  }

  seek(seconds) {
    if (!this.waveSurfer) return;
    this.waveSurfer.seekTo(seconds / this.waveSurfer.getDuration());
  }

  get currentIndex() {
    return Math.max(this.playlist.indexOf(this.currentSong.id), 0);
  }
}

export default Player;