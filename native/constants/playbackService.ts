import TrackPlayer, { Event } from 'react-native-track-player'

export const playbackService = async () => {
	TrackPlayer.addEventListener(Event.RemotePause, () => {
		TrackPlayer.pause()
	})

	TrackPlayer.addEventListener(Event.RemotePlay, () => {
		TrackPlayer.play()
	})

	TrackPlayer.addEventListener(Event.RemoteNext, () => {
		TrackPlayer.skipToNext()
	})

	TrackPlayer.addEventListener(Event.RemotePrevious, () => {
		TrackPlayer.skipToPrevious()
	})

	TrackPlayer.addEventListener(Event.RemoteJumpForward, async (event) => {
		TrackPlayer.seekBy(event.interval)
	})

	TrackPlayer.addEventListener(Event.RemoteJumpBackward, async (event) => {
		TrackPlayer.seekBy(-event.interval)
	})

	TrackPlayer.addEventListener(Event.RemoteSeek, async (event) => {
		TrackPlayer.seekTo(event.position)
	})

	TrackPlayer.addEventListener(Event.RemoteStop, () => {
		TrackPlayer.stop()
	})
}
