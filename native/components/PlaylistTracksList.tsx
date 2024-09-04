import { fontSize } from '@/constants/tokens'
import { trackTitleFilter } from '@/helpers/filter'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { Playlist, Tanda, Recording } from '@/graphql/__generated__/graphql'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useMemo } from 'react'
import { StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { QueueControls } from './QueueControls'
import { TracksList } from './TracksList'

export const PlaylistTracksList = ({ playlist }: { playlist: Playlist | Tanda }) => {
	const search = useNavigationSearch({
		searchBarOptions: {
			hideWhenScrolling: true,
			placeholder: 'Find in playlist',
		},
	})

	if (!playlist || !playlist.playlistItems) {
		return <Text>No playlist found or no items in the playlist</Text>
	}

	const recordings = useMemo(() => {
		return (
			playlist.playlistItems.edges.flatMap(({ node: item }: Recording | Tanda) => {
				if (item.item.__typename === 'Recording') {
					const recording = item.item
					const digitalRemasterNode = recording?.digitalRemasters?.edges[0]?.node
					const audioVariantNode = digitalRemasterNode?.audioVariants?.edges[0]?.node

					return {
						id: recording?.id || '',
						title: recording?.composition?.title || 'Untitled',
						artist: recording?.orchestra?.name || 'Unknown Artist',
						duration: digitalRemasterNode?.duration || 0,
						artwork: digitalRemasterNode?.album?.albumArt?.blob.url || '',
						url: audioVariantNode?.audioFile.blob.url || '',
						genre: recording?.genre?.name || 'Unknown Genre',
						year: recording?.year || 'Unknown Year',
					}
				}

				if (item.item.__typename === 'Tanda') {
					const tanda = item.item as Tanda

					return tanda.playlistItems.edges
						.map(({ node }) => node.item)
						.filter((item) => item.__typename === 'Recording')
						.map((recording) => ({
							id: recording.id,
							title: recording.composition.title,
							artist: recording.orchestra.name,
							duration: recording.digitalRemasters.edges[0].node.duration,
							artwork: recording.digitalRemasters.edges[0].node.album.albumArt.blob.url,
							url: recording.digitalRemasters.edges[0].node.audioVariants.edges[0].node.audioFile.blob.url,
							genre: recording.genre.name,
							year: recording.year,
						}))
				}

				return []
			}) || []
		)
	}, [playlist.playlistItems.edges])

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
								uri: playlist?.image?.blob?.url || require('@/assets/unknown_artist.png'),
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
