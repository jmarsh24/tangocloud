import { Track } from 'react-native-track-player'

export type Playlist = {
	id: string
	title: string
	tracks: Track[]
	artworkPreview: string
}

export type Artist = {
	name: string
	tracks: Track[]
}

export type TrackWithPlaylist = Track & { playlist?: string[] }
