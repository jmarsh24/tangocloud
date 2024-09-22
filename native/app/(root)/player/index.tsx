import { MovingText } from '@/components/MovingText'
import { PlayerControls } from '@/components/PlayerControls'
import { PlayerProgressBar } from '@/components/PlayerProgressbar'
import { ShareButton } from '@/components/ShareButton'
import { TracksListItem } from '@/components/TracksListItem'
import { colors, fontSize } from '@/constants/tokens'
import { SEARCH_RECORDINGS } from '@/graphql'
import { joinAttributes } from '@/helpers/miscellaneous'
import { usePlayerBackground } from '@/hooks/usePlayerBackground'
import { useTrackPlayerFavorite } from '@/hooks/useTrackPlayerFavorite'
import { useQueue } from '@/store/queue'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { FontAwesome, MaterialIcons } from '@expo/vector-icons'
import { LinearGradient } from 'expo-linear-gradient'
import { Link } from 'expo-router'
import { useMemo } from 'react'
import {
	ActivityIndicator,
	FlatList,
	Pressable,
	ScrollView,
	StyleSheet,
	Text,
	TouchableOpacity,
	View,
} from 'react-native'
import FastImage from 'react-native-fast-image'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import TrackPlayer, { useActiveTrack } from 'react-native-track-player'

const PlayerScreen = () => {
	const activeTrack = useActiveTrack()
	const { imageColors, readablePrimaryColor } = usePlayerBackground(
		activeTrack?.artwork ?? require('@/assets/unknown_track.png'),
	)

	const {
		data: relatedRecordingsData,
		loading: relatedRecordingsLoading,
		error: relatedRecordingsError,
	} = useQuery(SEARCH_RECORDINGS)

	const { top } = useSafeAreaInsets()

	const { isFavorite, toggleFavorite } = useTrackPlayerFavorite()

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

	const recentlyaddedRecordings = useMemo(() => {
		if (!relatedRecordingsData) return []

		return relatedRecordingsData.searchRecordings.recordings.edges
			.map((edge) => ({
				id: edge.node.id,
				title: edge.node.composition.title,
				artist: edge.node.orchestra?.name || 'Unknown Artist',
				duration: edge.node.digitalRemasters[0]?.audioVariants[0]?.duration || 0,
				artwork: edge.node.digitalRemasters[0]?.album?.albumArt?.url || '',
				url: edge.node.digitalRemasters[0]?.audioVariants[0].url || '',
				genre: edge.node.genre?.name || 'Unknown Genre',
				year: edge.node.year || 'Unknown Year',
			}))
			.filter((recording) => recording.id !== activeTrack?.id)
	}, [relatedRecordingsData, activeTrack?.id])

	if (relatedRecordingsLoading) {
    return (
      <View style={[defaultStyles.container, { justifyContent: 'center' }]}>
        <ActivityIndicator color={colors.icon} />
      </View>
    )
  }

  if (relatedRecordingsError) {
    return (
      <View style={[defaultStyles.container, { justifyContent: 'center' }]}>
        <Text style={defaultStyles.text}>Error fetching related recordings</Text>
      </View>
    )
  }

	if (!activeTrack) {
		return (
			<View style={[defaultStyles.container, { justifyContent: 'center' }]}>
				<ActivityIndicator color={colors.icon} />
			</View>
		)
	}

	return (
		<LinearGradient
			style={styles.linearGradient}
			colors={
				imageColors && imageColors.platform
					? imageColors.platform === 'android' && imageColors.dominant && imageColors.average
						? [imageColors.dominant, imageColors.average]
						: imageColors.platform === 'ios' && imageColors.secondary && imageColors.detail
							? [imageColors.secondary, imageColors.detail]
							: [colors.background, colors.backgroundDarker]
					: [colors.background, colors.backgroundDarker]
			}
		>
			<View style={[styles.overlayContainer]}>
				<ScrollView
					style={[styles.scrollContainer]}
					showsVerticalScrollIndicator={false}
					snapToAlignment="start"
				>
					<View style={{ display: 'flex', gap: 72, paddingBottom: 36 }}>
						<View style={{ display: 'flex', gap: 36 }}>
							<View style={styles.artworkImageContainer}>
								<FastImage
									source={{
										uri: activeTrack.artwork ?? require('@/assets/unknown_track.png'),
										priority: FastImage.priority.high,
									}}
									resizeMode="cover"
									style={styles.artworkImage}
								/>
							</View>
							<View>
								<View style={{ flexDirection: 'column', gap: 24 }}>
									<View>
										<View
											style={{
												flexDirection: 'row',
												justifyContent: 'space-between',
												alignItems: 'center',
											}}
										>
											<View style={styles.trackTitleContainer}>
												<MovingText
													text={activeTrack.title ?? ''}
													animationThreshold={30}
													style={styles.trackTitleText}
												/>
											</View>
											<View style={{ flexDirection: 'row', gap: 12 }}>
												<TouchableOpacity activeOpacity={0.7} onPress={toggleFavorite}>
													<FontAwesome
														name={isFavorite ? 'heart' : 'heart-o'}
														size={28}
														color={isFavorite ? colors.primary : colors.icon}
													/>
												</TouchableOpacity>
												<ShareButton recording_id={activeTrack.id} />
												<Link href="/queue" asChild>
													<MaterialIcons name="queue-music" size={30} color="white" />
												</Link>
											</View>
										</View>

										{activeTrack.artist && (
											<Text numberOfLines={1} style={[styles.trackArtistText, { paddingTop: 6 }]}>
												{`${joinAttributes([activeTrack.artist, activeTrack.singer])}`}
											</Text>
										)}
										<Text numberOfLines={1} style={styles.trackArtistText}>
											{`${joinAttributes([activeTrack.genre, activeTrack.year])}`}
										</Text>
									</View>

									<PlayerProgressBar />

									<PlayerControls />
								</View>
							</View>
						</View>
						{activeTrack.lyrics && (
							<Link
								href="/lyrics"
								style={[
									{
										backgroundColor: readablePrimaryColor,
									},
									styles.lyricsContainer,
								]}
								asChild
							>
								<Pressable>
									<View
										style={{
											flexDirection: 'row',
											justifyContent: 'space-between',
											alignItems: 'center',
										}}
									>
										<Text style={styles.lyricsHeader}>Lyrics</Text>
										<View
											style={{ borderRadius: 24, backgroundColor: 'rgba(0,0,0,0.2)', padding: 10 }}
										>
											<MaterialIcons name="open-in-full" size={18} color={colors.text} />
										</View>
									</View>
									<Text numberOfLines={8} style={styles.lyricsText}>
										{activeTrack.lyrics}
									</Text>
								</Pressable>
							</Link>
						)}
					</View>
					<View>
						{recentlyaddedRecordings.length > 0 && (
							<View
								style={{
									flexDirection: 'column',
									gap: 12,
									padding: 24,
									borderRadius: 32,
									backgroundColor: 'rgba(0,0,0,0.2)',
									marginBottom: 36,
								}}
							>
								<Text style={[defaultStyles.text, styles.header]}>Related Recordings</Text>
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
						)}
					</View>
				</ScrollView>
			</View>
		</LinearGradient>
	)
}

const styles = StyleSheet.create({
	header: {
		fontSize: 24,
		fontWeight: 'bold',
		color: colors.text,
	},
	linearGradient: {
		flex: 1,
		borderTopRightRadius: 24,
		borderTopLeftRadius: 24,
	},
	overlayContainer: {
		...defaultStyles.container,
		paddingHorizontal: 12,
		backgroundColor: 'rgba(0,0,0,0.5)',
		borderTopRightRadius: 24,
		borderTopLeftRadius: 24,
	},
	scrollContainer: {
		paddingTop: 24,
		paddingHorizontal: 12,
		zIndex: 10,
	},
	artworkImageContainer: {
		shadowOffset: {
			width: 0,
			height: 4,
		},
		shadowOpacity: 0.44,
		shadowRadius: 8.0,
	},
	artworkImage: {
		width: '100%',
		resizeMode: 'cover',
		borderRadius: 12,
		aspectRatio: 1,
	},
	trackTitleContainer: {
		flex: 1,
		overflow: 'hidden',
	},
	trackTitleText: {
		...defaultStyles.text,
		fontSize: 22,
		fontWeight: '700',
	},
	trackArtistText: {
		...defaultStyles.text,
		fontSize: fontSize.base,
		opacity: 0.8,
		maxWidth: '90%',
	},
	lyricsContainer: {
		gap: 24,
		padding: 24,
		borderTopRightRadius: 24,
		borderTopLeftRadius: 24,
		borderBottomLeftRadius: 38,
		borderBottomRightRadius: 38,
	},
	lyricsHeader: {
		...defaultStyles.text,
		fontSize: fontSize.base,
		fontWeight: '600',
	},
	lyricsText: {
		...defaultStyles.textLyrics,
		fontSize: fontSize.lg,
		fontWeight: '700',
	},
})

export default PlayerScreen
