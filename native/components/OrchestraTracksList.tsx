import { fontSize } from '@/constants/tokens'
import { trackTitleFilter } from '@/helpers/filter'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useMemo } from 'react'
import { StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { QueueControls } from './QueueControls'
import { TracksList } from './TracksList'

export const OrchestraTracksList = ({ orchestra }: { orchestra: Orchestra }) => {
	const search = useNavigationSearch({
		searchBarOptions: {
			hideWhenScrolling: true,
			placeholder: 'Find in recordings',
		},
	})

	const recordings =
		orchestra?.recordings?.edges.map(({ node: item }) => ({
			id: item.id,
			title: item.title,
			artist: orchestra.name,
			duration: item.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: item.audioTransfers[0]?.album?.albumArtUrl,
			url: item.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
			genre: item.genre?.name,
			year: item.year,
			singer: item.singers[0]?.name,
		})) || []

	const filteredArtistTracks = useMemo(() => {
		return recordings.filter(trackTitleFilter(search))
	}, [recordings, search])

	return (
		<TracksList
			id={generateTracksListId(orchestra.name, search)}
			scrollEnabled={false}
			hideQueueControls={true}
			ListHeaderComponentStyle={styles.artistHeaderContainer}
			ListHeaderComponent={
				<View>
					<View style={styles.artworkImageContainer}>
						<FastImage
							source={{
								uri: orchestra.photoUrl || require('@/assets/unknown_artist.png'),
								priority: FastImage.priority.high,
							}}
							style={styles.artistImage}
						/>
					</View>

					<Text numberOfLines={1} style={styles.artistNameText}>
						{orchestra.name}
					</Text>

					{search.length === 0 && (
						<QueueControls tracks={filteredArtistTracks} style={{ paddingTop: 24 }} />
					)}
				</View>
			}
			tracks={filteredArtistTracks}
		/>
	)
}

const styles = StyleSheet.create({
	artistHeaderContainer: {
		flex: 1,
		marginBottom: 32,
	},
	artworkImageContainer: {
		flexDirection: 'row',
		justifyContent: 'center',
		height: 200,
	},
	artistImage: {
		width: '60%',
		height: '100%',
		resizeMode: 'cover',
		borderRadius: 128,
	},
	artistNameText: {
		...defaultStyles.text,
		marginTop: 22,
		textAlign: 'center',
		fontSize: fontSize.lg,
		fontWeight: '800',
	},
})
