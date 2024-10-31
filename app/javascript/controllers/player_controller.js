import { Controller } from '@hotwired/stimulus';
import { formatDuration, dispatchEvent } from '../helper';
import { installEventHandler } from './mixins/event_handler';

export default class extends Controller {
  static targets = [
    'header',
    'image',
    'backgroundImage',
    'songName',
    'artistName',
    'albumName',
    'songDuration',
    'songTimer',
    'progress',
    'playButton',
    'pauseButton',
    'favoriteButton',
    'unFavoriteButton',
    'modeButton',
    'loader',
    'container'
  ];

  initialize() {
    this.#initMode();
    installEventHandler(this);
  }

  connect() {
    this.handleEvent('player:beforePlaying', { with: this.#setBeforePlayingStatus });
    this.handleEvent('player:playing', { with: this.#setPlayingStatus });
    this.handleEvent('player:pause', { with: this.#setPauseStatus });
    this.handleEvent('player:stop', { with: this.#setStopStatus });
    this.handleEvent('player:end', { with: this.#setEndStatus });
  }

  play() {
    this.player.play();
  }

  pause() {
    this.player.pause();
  }

  toggleFavorite(event) {
    if (!event.detail.success) return;

    const isFavorited = this.currentSong.is_favorited;
    this.currentSong.is_favorited = !isFavorited;
    this.favoriteButtonTarget.classList.toggle('hidden', !isFavorited);
    this.unFavoriteButtonTarget.classList.toggle('hidden', isFavorited);
  }

  nextMode() {
    if (this.currentModeIndex + 1 >= this.modes.length) {
      this.currentModeIndex = 0;
    } else {
      this.currentModeIndex += 1;
    }

    this.updateMode();
  }

  updateMode() {
    this.modeButtonTargets.forEach((element) => {
      element.classList.toggle('hidden', element !== this.modeButtonTargets[this.currentModeIndex]);
    });

    this.player.playlist.isShuffled = this.currentMode === 'shuffle';
  }

  next() {
    this.player.next();
  }

  previous() {
    this.player.previous();
  }

  seek(event) {
    const seekTime = (event.offsetX / event.target.offsetWidth) * this.currentSong.duration;
    this.player.seek(seekTime);
    window.requestAnimationFrame(this.#setProgress.bind(this));
  }

  collapse() {
    document.querySelector('#js-sidebar').classList.remove('is-expanded');
  }

  get player() {
    return App.player;
  }

  get currentIndex() {
    return this.player.currentIndex;
  }

  get currentSong() {
    return this.player.currentSong;
  }

  get currentMode() {
    return this.modes[this.currentModeIndex];
  }

  get currentTime() {
    const currentTime = this.player.waveSurfer?.getCurrentTime() || 0;
    return Math.round(currentTime);
  }

  get isEndOfPlaylist() {
    return this.currentIndex === this.player.playlist.length - 1;
  }

  #setBeforePlayingStatus = () => {
    this.headerTarget.classList.add('expanded');
    this.loaderTarget.classList.remove('hidden');
    this.favoriteButtonTarget.classList.remove('invisible');
    this.songTimerTarget.textContent = formatDuration(0);
  }

  #setPlayingStatus = () => {
    const { currentSong } = this;
    const favoriteSongUrl = `/favorite_playlist/songs?song_id=${currentSong.id}`;
    const unFavoriteSongUrl = `/favorite_playlist/songs/${currentSong.id}`;

    this.imageTarget.src = currentSong.album_image_url.small;
    this.backgroundImageTarget.style.backgroundImage = `url(${currentSong.album_image_url.small})`;
    this.songNameTarget.textContent = currentSong.name;
    this.artistNameTarget.textContent = currentSong.artist_name;
    this.albumNameTarget.textContent = currentSong.album_name;
    this.songDurationTarget.textContent = formatDuration(currentSong.duration);

    this.pauseButtonTarget.classList.remove('hidden');
    this.playButtonTarget.classList.add('hidden');
    this.loaderTarget.classList.add('hidden');

    this.favoriteButtonTarget.classList.toggle('hidden', currentSong.is_favorited);
    this.unFavoriteButtonTarget.classList.toggle('hidden', !currentSong.is_favorited);
    this.favoriteButtonTarget.action = favoriteSongUrl;
    this.unFavoriteButtonTarget.action = unFavoriteSongUrl;

    window.requestAnimationFrame(this.#setProgress.bind(this));
    this.timerInterval = setInterval(this.#setTimer.bind(this), 1000);

    dispatchEvent(document, 'songs:showPlaying');
  }

  #setPauseStatus = () => {
    this.#clearTimerInterval();
    this.pauseButtonTarget.classList.add('hidden');
    this.playButtonTarget.classList.remove('hidden');
  }

  #setStopStatus = () => {
    this.#setPauseStatus();

    if (!this.currentSong.id) {
      this.headerTarget.classList.remove('expanded');
      dispatchEvent(document, 'songs:hidePlaying');
    }
  }

  #setEndStatus = () => {
    this.#clearTimerInterval();

    switch (this.currentMode) {
      case 'noRepeat':
        if (this.isEndOfPlaylist) {
          this.player.stop();
        } else {
          this.next();
        }
        break;
      case 'single':
        this.player.play();
        break;
      default:
        this.next();
    }
  }

  #setProgress() {
    this.progressTarget.value = (this.currentTime / this.currentSong.duration) * 100 || 0;

    if (this.player.isPlaying) {
      window.requestAnimationFrame(this.#setProgress.bind(this));
    }
  }

  #setTimer() {
    this.songTimerTarget.textContent = formatDuration(this.currentTime);
  }

  #clearTimerInterval() {
    if (this.timerInterval) {
      clearInterval(this.timerInterval);
    }
  }

  #initMode() {
    this.modes = ['noRepeat', 'repeat', 'single', 'shuffle'];
    this.currentModeIndex = 0;
    this.updateMode();
  }
}