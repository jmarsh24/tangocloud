import { fontSize } from '@/constants/tokens'
import { trackTitleFilter } from '@/helpers/filter'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { Playlist } from '@/helpers/types'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useMemo } from 'react'
import { StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { QueueControls } from './QueueControls'
import { TracksList } from './TracksList'

export const PlaylistTracksList = ({ playlist }: { playlist: Playlist }) => {
	const search = useNavigationSearch({
		searchBarOptions: {
			hideWhenScrolling: true,
			placeholder: 'Find in playlist',
		},
	})

	const recordings = useMemo(
		() =>
			playlist.playlistItems.map((item) => {
				const recording = item.playable
				return {
					id: recording.id,
					title: recording.title,
					artist: recording.orchestra.name,
					duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
					artwork: recording.audioTransfers[0]?.album?.albumArtUrl || '',
					url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
					orchestraImageUrl: recording.orchestra.photoUrl,
					lyrics: recording?.composition?.lyrics[0]?.content,
					genre: recording.genre.name,
					year: recording.year,
					singer: recording.singers[0]?.name,
					composer: recording?.composition?.composer?.name,
					lyricist: recording?.composition?.lyricist?.name,
				}
			}),
		[playlist.playlistItems],
	)

	const filteredPlaylistTracks = useMemo(
		() => recordings.filter(trackTitleFilter(search)),
		[recordings, search],
	)

	return (
		<TracksList
			id={generateTracksListId(playlist.title, search)}
			scrollEnabled={false}
			hideQueueControls={true}
			ListHeaderComponentStyle={styles.playlistHeaderContainer}
			ListHeaderComponent={
				<View>
					<View style={styles.artworkImageContainer}>
						<FastImage
							source={{
								uri: playlist.imageUrl,
								priority: FastImage.priority.high,
							}}
							style={styles.artworkImage}
						/>
					</View>

					<Text numberOfLines={1} style={styles.playlistNameText}>
						{playlist.title}
					</Text>

					{search.length === 0 && <QueueControls style={{ paddingTop: 24 }} tracks={recordings} />}
				</View>
			}
			tracks={filteredPlaylistTracks}
		/>
	)
}

const styles = StyleSheet.create({
	playlistHeaderContainer: {
		flex: 1,
		marginBottom: 32,
		gap: 24,
	},
	artworkImageContainer: {
		flexDirection: 'row',
		justifyContent: 'center',
	},
	artworkImage: {
		width: '85%',
		aspectRatio: 1,
		resizeMode: 'cover',
		borderRadius: 12,
	},
	playlistNameText: {
		...defaultStyles.text,
		marginTop: 22,
		textAlign: 'center',
		fontSize: fontSize.lg,
		fontWeight: '800',
	},
})