import { Playlist } from './types'

export const trackTitleFilter = (title: string) => (track: any) =>
	track.title?.toLowerCase().includes(title.toLowerCase())

export const artistNameFilter = (name: string) => (orchestra: Orchestra) =>
	orchestra.name.toLowerCase().includes(name.toLowerCase())

export const playlistNameFilter = (title: string) => (playlist: Playlist) =>
	playlist.title.toLowerCase().includes(title.toLowerCase())
