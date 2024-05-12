import { FETCH_ORCHESTRA } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useLocalSearchParams } from 'expo-router'
import { useEffect } from 'react'
import { ActivityIndicator, Image, StyleSheet, Text, View, ScrollView, FlatList } from 'react-native'
import { defaultStyles } from '@/styles'
import { SafeAreaView } from 'react-native-safe-area-context'
import { TracksListItem } from '@/components/TracksListItem'
import { useQueue } from '@/store/queue'
import TrackPlayer from 'react-native-track-player'
import { colors } from '@/constants/tokens'
import { screenPadding } from '@/constants/tokens'

const OrchestraScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { activeQueueId, setActiveQueueId } = useQueue()
	const { data, loading, error } = useQuery(FETCH_ORCHESTRA, { variables: { id } })

	const handleTrackSelect = async (track) => {
		const id = track.id
		const queue = await TrackPlayer.getQueue()
		const trackIndex = queue.findIndex((qTrack) => qTrack.id === track.id)
		const isChangingQueue = id !== activeQueueId

		if (isChangingQueue || trackIndex === -1) {
			if (trackIndex === -1) {
				await TrackPlayer.add(track)
			}
			await TrackPlayer.skipToNext()
			setActiveQueueId(id)
		} else {
			await TrackPlayer.skip(trackIndex)
		}

		TrackPlayer.play()
	}

	const orchestra = data?.fetchOrchestra
	
	const recordings = orchestra?.recordings?.edges.map(({ node: item }) => ({
			id: item.id,
			title: item.title,
			artist: orchestra.name,
			duration: item.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: item.audioTransfers[0]?.album?.albumArtUrl,
			url: item.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
			genre: item.genre?.name,
			year: item.year,
			singer: item.singers[0]?.name,
	})) || [];

	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<ActivityIndicator size="large" />
			</View>
		)
	}

	if (error) {
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading orchestra.</Text>
			</View>
		)
	}

	return (
		<SafeAreaView style={defaultStyles.container}>
			<ScrollView>
				<View style={styles.imageContainer}>
					<Image source={{ uri: orchestra.photoUrl }} style={styles.image} />
					<Text style={[styles.title, { color: colors.text }]}>{orchestra.name}</Text>
				</View>
				<View style={{ flexDirection: 'column', gap: 12, paddingBottom: 108, paddingHorizontal: screenPadding.horizontal} }>
					<Text style={[defaultStyles.text, styles.header]}>
						Discography
					</Text>
					<FlatList
						data={recordings}
						renderItem={({ item }) => (
							<TracksListItem track={item} onTrackSelect={() => handleTrackSelect(item)} />
						)}
						contentContainerStyle={{ gap: 12 }}
						keyExtractor={(item) => item.id}
					/>
				</View>
			</ScrollView>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	header: {
		fontSize: 24,
		fontWeight: 'bold',
	},
	loadingContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
	},
	errorContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
	},
	imageContainer: {
		paddingBottom: 10,
		position: 'relative',
		alignItems: 'center',
	},
	image: {
		width: '100%',
		height: 300,
	},
	title: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingLeft: 10,
    paddingBottom: 10,
    color: '#FFFFFF',
    textShadowColor: 'rgba(0, 0, 0, 0.75)',
    textShadowOffset: { width: -1, height: 1 },
    textShadowRadius: 10
},
})

export default OrchestraScreen
