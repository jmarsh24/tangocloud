import { PlaylistButton } from '@/components/PlaylistButton'
import { TracksListItem } from '@/components/TracksListItem'
import { colors, screenPadding } from '@/constants/tokens'
import { ORCHESTRAS, PLAYLISTS, SEARCH_RECORDINGS, TANDA_OF_THE_WEEK } from '@/graphql'
import { joinAttributes } from '@/helpers/miscellaneous'
import { useQueue } from '@/store/queue'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { Link } from 'expo-router'
import _ from 'lodash'
import { useMemo } from 'react'
import {
	ActivityIndicator,
	FlatList,
	Pressable,
	SafeAreaView,
	ScrollView,
	StyleSheet,
	Text,
	View,
} from 'react-native'
import FastImage from 'react-native-fast-image'
import TrackPlayer from 'react-native-track-player'

const HomeScreen = () => {
	const {
		data: playlistData,
		loading: playlistLoading,
		error: playlistsError,
	} = useQuery(PLAYLISTS, {
		variables: { query: '*' },
		fetchPolicy: 'cache-and-network',
	})

	const {
		data: popularRecordingsData,
		loading: popularRecordingsLoading,
		error: popularRecordingsError,
	} = useQuery(SEARCH_RECORDINGS, {
		variables: { first: 32 },
		fetchPolicy: 'cache-and-network',
	})

	const {
		data: recentlyaddedRecordingsData,
		loading: recentlyaddedRecordingsLoading,
		error: recentlyaddedRecordingsError,
	} = useQuery(SEARCH_RECORDINGS, {
		variables: { query: '*', first: 32, sortBy: 'created_at', order: 'desc' },
		fetchPolicy: 'cache-and-network',
	})

	const {
		data: tandaOfTheWeekData,
		loading: tandaOfTheWeekLoading,
		error: tandaOfTheWeekError,
	} = useQuery(TANDA_OF_THE_WEEK, {
		variables: { query: 'tanda of the week', first: 10 },
		fetchPolicy: 'cache-and-network',
	})

	const {
		data: moodPlaylistsData,
		loading: moodPlaylistsLoading,
		error: moodPlaylistsError,
	} = useQuery(PLAYLISTS, {
		variables: { first: 8 },
		fetchPolicy: 'cache-and-network',
	})

	const {
		data: orchestrasData,
		loading: orchestrasLoading,
		error: orchestrasError,
	} = useQuery(ORCHESTRAS, {
		variables: { query: '*' },
		fetchPolicy: 'cache-and-network',
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
		const items = playlistData?.playlists?.edges.map((edge) => edge.node) ?? []
		return items.sort(() => Math.random() - 0.5).slice(0, 8)
	}, [playlistData])

	const popularRecordings = useMemo(() => {
		if (!popularRecordingsData) return []
		const recordings = popularRecordingsData.searchRecordings.recordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.composition.title,
			artist: edge.node.orchestra?.name || 'Unknown Artist',
			duration: edge.node.digitalRemasters.edges[0].node.duration || 0,
			artwork: edge.node.digitalRemasters.edges[0].node.album.albumArt.blob.url || '',
			url: edge.node.digitalRemasters.edges[0].node.audioVariants?.audioFile.blob.url || '',
			genre: edge.node.genre?.name || 'Unknown Genre',
			year: edge.node.year || 'Unknown Year',
		}))
		return shuffleAndSlice(recordings, 4)
	}, [popularRecordingsData])

	const recentlyaddedRecordings = useMemo(() => {
		if (!recentlyaddedRecordingsData) return []

		const recordings = popularRecordingsData.searchRecordings.recordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.composition.title,
			artist: edge.node.orchestra?.name || 'Unknown Artist',
			duration: edge.node.digitalRemasters.edges[0].node.duration || 0,
			artwork: edge.node.digitalRemasters.edges[0].node.album.albumArt.blob.url || '',
			url: edge.node.digitalRemasters.edges[0].node.audioVariants?.audioFile.blob.url || '',
			genre: edge.node.genre?.name || 'Unknown Genre',
			year: edge.node.year || 'Unknown Year',
		}))
		return shuffleAndSlice(recordings, 4)
	}, [recentlyaddedRecordingsData])

	const tandaOfTheWeek = useMemo(() => {
		const tandas = tandaOfTheWeekData?.searchPlaylists?.edges.map((edge) => edge.node) ?? []
		return tandas
	}, [tandaOfTheWeekData])

	const moodPlaylists = moodPlaylistsData?.playlists?.edges.map((edge) => edge.node) ?? []

	const orchestras = useMemo(() => {
		const sortedOrchestras =
			orchestrasData?.orchestras?.edges
				.map((edge) => edge.node)
				.sort((a, b) => b.recordingsCount - a.recordingsCount) ?? []

		return sortedOrchestras
	}, [orchestrasData])
	if (
		playlistLoading ||
		popularRecordingsLoading ||
		recentlyaddedRecordingsLoading ||
		tandaOfTheWeekLoading ||
		moodPlaylistsLoading ||
		orchestrasLoading
	) {
		return <ActivityIndicator size="large" color="#0000ff" />
	}

	if (
		playlistsError ||
		popularRecordingsError ||
		recentlyaddedRecordingsError ||
		tandaOfTheWeekError ||
		moodPlaylistsError ||
		orchestrasError
	) {
		return (
			<View style={styles.errorTextContainer}>
				<Text style={styles.errorText}>Error loading playlists: {playlistsError?.message}</Text>
				<Text style={styles.errorText}>
					Error loading popular recordings: {popularRecordingsError?.message}
				</Text>
				<Text style={styles.errorText}>
					Error loading recently added recordings: {recentlyaddedRecordingsError?.message}
				</Text>
				<Text style={styles.errorText}>
					Error loading tanda of the week: {tandaOfTheWeekError?.message}
				</Text>
				<Text style={styles.errorText}>
					Error loading mood playlists: {moodPlaylistsError?.message}
				</Text>
				<Text style={styles.errorText}>Error loading orchestras: {orchestrasError?.message}</Text>
			</View>
		)
	}

	return (
		<SafeAreaView
			style={{
				...defaultStyles.container
			}}
		>
			<ScrollView showsVerticalScrollIndicator={false}>
				{/* <View style={{ gap: 10 }}>
					<Text style={[defaultStyles.text, styles.subHeader, { paddingHorizontal: 20 }]}>
						Moods
					</Text>
					<FlatList
						data={moodPlaylists}
						horizontal={true}
						showsHorizontalScrollIndicator={false}
						directionalLockEnabled={true}
						alwaysBounceVertical={false}
						contentContainerStyle={{
							paddingHorizontal: 10,
						}}
						renderItem={({ item }) => (
							<Link href={`/playlists/${item.id}`} key={item.id} asChild>
								<Pressable style={styles.pillButton}>
									<Text style={styles.pillButtonText}>{item.title}</Text>
								</Pressable>
							</Link>
						)}
						keyExtractor={(item) => item.id}
					/>
				</View> */}
				<View
					style={{
						...defaultStyles.container,
						paddingHorizontal: screenPadding.horizontal,
						display: 'flex',
						gap: 24,
						paddingBottom: screenPadding.vertical,
					}}
				>
					<View style={{ flexDirection: 'column', gap: 24 }}>
						<Text style={(defaultStyles.text, styles.subHeader)}>Playlists</Text>
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
					{tandaOfTheWeek && tandaOfTheWeek.length > 0 && (
						<View
							style={{
								flexDirection: 'column',
								gap: 12,
							}}
						>
							<Text style={[defaultStyles.text, styles.header]}>Tanda of the Week</Text>
							<FlatList
								data={tandaOfTheWeek}
								horizontal
								showsHorizontalScrollIndicator={false}
								directionalLockEnabled={true}
								alwaysBounceVertical={false}
								contentContainerStyle={{ gap: 16 }}
								renderItem={({ item }) => (
									<Link push href={`/playlists/${item.id}`} key={item.id} asChild>
										<Pressable style={styles.tandaContainer}>
											<FastImage
												source={{ uri: item.image.blob.url, priority: FastImage.priority.normal }}
												style={styles.tandaImage}
												resizeMode={FastImage.resizeMode.cover}
											/>
											<View style={styles.overlayTextContainer}>
												<Text style={styles.tandaTitle}>{item.title}</Text>
												{item.playlistItems.slice(0, 4).map((item) => (
													<View key={item.id} style={styles.recordingDetailContainer}>
														<Text style={styles.recordingDetail}>
															{joinAttributes([item.playable.title, item.playable.year])}
														</Text>
													</View>
												))}
											</View>
										</Pressable>
									</Link>
								)}
								keyExtractor={(item) => item.id}
							/>
						</View>
					)}
					<View style={{ flexDirection: 'column', gap: 12 }}>
						<Text style={(defaultStyles.text, styles.header)}>Popular Recordings</Text>
						<FlatList
							data={popularRecordings}
							scrollEnabled={false}
							renderItem={({ item }) => (
								<TracksListItem track={item} onTrackSelect={() => handleTrackSelect(item)} />
							)}
							contentContainerStyle={{ gap: 12 }}
							keyExtractor={(item) => item.id}
						/>
					</View>
					<View style={{ flexDirection: 'column', gap: 12 }}>
						<Text style={(defaultStyles.text, styles.header)}>Recently Added</Text>
						<FlatList
							data={recentlyaddedRecordings}
							scrollEnabled={false}
							renderItem={({ item }) => (
								<TracksListItem track={item} onTrackSelect={() => handleTrackSelect(item)} />
							)}
							contentContainerStyle={{ gap: 12 }}
							keyExtractor={(item) => item.id}
						/>
					</View>
					<View style={{ flexDirection: 'column', gap: 12 }}>
						<Text style={[defaultStyles.text, styles.header]}>Main Orchestras</Text>
						<FlatList
							data={orchestras}
							horizontal
							showsHorizontalScrollIndicator={false}
							directionalLockEnabled={true}
							alwaysBounceVertical={false}
							contentContainerStyle={{ gap: 16 }}
							renderItem={({ item }) => (
								<Link href={`/orchestras/${item.id}`} key={item.id} asChild>
									<Pressable style={{ alignItems: 'center', gap: 16 }}>
										<FastImage
											source={{ uri: item.image.blob.url }}
											style={{ width: 170, height: 170, borderRadius: 100 }}
										/>
										<Text style={styles.orchestraText}>{item.name}</Text>
									</Pressable>
								</Link>
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
	container: {
		flex: 1,
		backgroundColor: 'red',
	},
	contentContainer: {
		flexDirection: 'column',
		gap: 12,
		paddingHorizontal: screenPadding.horizontal,
		paddingBottom: screenPadding.vertical,
	},
	header: {
		fontSize: 24,
		fontWeight: 'bold',
		color: colors.text,
	},
	subHeader: {
		fontSize: 14,
		fontWeight: 'bold',
		color: 'rgba(235, 235, 245, 0.6)',
		paddingHorizontal: 20,
	},
	tandaContainer: {
		position: 'relative',
		marginBottom: 24,
		height: 200,
	},
	tandaImage: {
		width: 300,
		height: 200,
		borderRadius: 8,
	},
	overlayTextContainer: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		right: 0,
		backgroundColor: 'rgba(0, 0, 0, 0.5)',
		padding: 10,
	},
	tandaTitle: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 18,
	},
	recordingDetailContainer: {
		marginTop: 4,
	},
	recordingDetail: {
		color: 'white',
	},
	pillButton: {
		backgroundColor: 'rgba(46, 47, 51, 1)',
		paddingHorizontal: 15,
		paddingVertical: 8,
		borderRadius: 20,
		marginHorizontal: 5,
		marginBottom: 10,
		alignItems: 'center',
		justifyContent: 'center',
	},
	pillButtonText: {
		color: 'white',
		fontWeight: 'bold',
	},

	orchestraText: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 18,
	},

	errorTextContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
		padding: 20,
		backgroundColor: 'black',
	},
	errorText: {
		color: 'white',
		fontSize: 16,
		marginBottom: 10,
	},
})

export default HomeScreen
