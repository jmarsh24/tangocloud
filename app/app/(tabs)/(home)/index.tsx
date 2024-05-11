import { PlaylistButton } from '@/components/PlaylistButton'
import { TracksListItem } from '@/components/TracksListItem'
import { colors, screenPadding } from '@/constants/tokens'
import { SEARCH_PLAYLISTS, SEARCH_RECORDINGS } from '@/graphql'
import { useQueue } from '@/store/queue'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { Link } from 'expo-router'
import _ from 'lodash'
import { useMemo } from 'react'
import {
	ActivityIndicator,
	FlatList,
	SafeAreaView,
	ScrollView,
	StyleSheet,
	Text,
	View,
} from 'react-native'
import TrackPlayer from 'react-native-track-player'

const HomeScreen = () => {
	const {
		data: playlistData,
		loading: playlistLoading,
		error: playlistsError,
	} = useQuery(SEARCH_PLAYLISTS, {
		variables: { query: '*' },
	})

	const {
		data: popularRecordingsData,
		loading: popularRecordingsLoading,
		error: popularRecordingsError,
	} = useQuery(SEARCH_RECORDINGS, {
		variables: { first: 32 },
	})

	const {
		data: recentlyaddedRecordingsData,
		loading: recentlyaddedRecordingsLoading,
		error: recentlyaddedRecordingsError,
	} = useQuery(SEARCH_RECORDINGS, {
		variables: { query: '*', first: 32, sort_by: 'created_at', order: 'desc' },
	})

	const shuffleAndSlice = (data, count = 3) => {
		return _.shuffle(data).slice(0, count)
	}

	const { activeQueueId, setActiveQueueId } = useQueue()

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

	const playlists = useMemo(() => {
		const items = playlistData?.searchPlaylists?.edges.map((edge) => edge.node) ?? []
		return items.sort(() => Math.random() - 0.5).slice(0, 8)
	}, [playlistData])

	if (playlistLoading || popularRecordingsLoading || recentlyaddedRecordingsLoading) {
		return <ActivityIndicator size="large" color="#0000ff" />
	}

	if (playlistsError || popularRecordingsError || recentlyaddedRecordingsError) {
		return (
			<View>
				<Text>Error loading playlists: {playlistsError}</Text>
				<Text>Error loading popular recordings: {popularRecordingsError}</Text>
			</View>
		)
	}

	const popularRecordings = useMemo(() => {
		if (!popularRecordingsData) return []
		const recordings = popularRecordingsData.searchRecordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.title,
			artist: edge.node.orchestra?.name || 'Unknown Artist',
			duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || '',
			url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
			genre: edge.node.genre?.name || 'Unknown Genre',
			year: edge.node.year || 'Unknown Year',
		}))
		return shuffleAndSlice(recordings, 3)
	}, [popularRecordingsData])

	const recentlyaddedRecordings = useMemo(() => {
		if (!recentlyaddedRecordingsData) return []
		const recordings = recentlyaddedRecordingsData.searchRecordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.title,
			artist: edge.node.orchestra?.name || 'Unknown Artist',
			duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || '',
			url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
			genre: edge.node.genre?.name || 'Unknown Genre',
			year: edge.node.year || 'Unknown Year',
		}))
		return shuffleAndSlice(recordings, 3)
	}, [recentlyaddedRecordingsData])

	return (
		<SafeAreaView
			style={{
				...defaultStyles.container,
				marginBottom: screenPadding.vertical,
			}}
		>
			<ScrollView>
				<View
					style={{
						...defaultStyles.container,
						paddingHorizontal: screenPadding.horizontal,
						display: 'flex',
						gap: 24,
					}}
				>
					<View style={{ flexDirection: 'column', gap: 24 }}>
						<FlatList
							data={playlists}
							renderItem={({ item }) => <PlaylistButton playlist={item} />}
							numColumns={2}
							keyExtractor={(item) => item.id}
							columnWrapperStyle={{ gap: 8 }}
							contentContainerStyle={{ gap: 8 }}
							scrollEnabled={false}
							style={{ flexGrow: 0 }}
						/>
						<Link style={[defaultStyles.text, { color: colors.primary }]} href="/playlists">
							See All Playlists
						</Link>
					</View>
					<View style={{ flexDirection: 'column', gap: 12 }}>
						<Text style={(defaultStyles.text, styles.header)}>Popular Recordings</Text>
						<FlatList
							data={popularRecordings}
							renderItem={({ item }) => (
								<TracksListItem track={item} onTrackSelect={() => handleTrackSelect(item)} />
							)}
							keyExtractor={(item) => item.id}
						/>
					</View>
					<View style={{ flexDirection: 'column', gap: 12 }}>
						<Text style={(defaultStyles.text, styles.header)}>Recently Added</Text>
						<FlatList
							data={recentlyaddedRecordings}
							renderItem={({ item }) => (
								<TracksListItem track={item} onTrackSelect={() => handleTrackSelect(item)} />
							)}
							keyExtractor={(item) => item.id}
						/>
					</View>
				</View>
			</ScrollView>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	header: {
		fontSize: 24,
		fontWeight: 'bold',
		color: colors.text,
	},
})

export default HomeScreen
