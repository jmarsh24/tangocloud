import { MovingText } from '@/components/MovingText'
import { PlayerControls } from '@/components/PlayerControls'
import { PlayerProgressBar } from '@/components/PlayerProgressbar'
import { ShareButton } from '@/components/ShareButton'
import { colors, fontSize } from '@/constants/tokens'
import { joinAttributes } from '@/helpers/miscellaneous'
import { usePlayerBackground } from '@/hooks/usePlayerBackground'
import { useTrackPlayerFavorite } from '@/hooks/useTrackPlayerFavorite'
import { defaultStyles } from '@/styles'
import { FontAwesome, MaterialIcons } from '@expo/vector-icons'
import { LinearGradient } from 'expo-linear-gradient'
import { Link } from 'expo-router'
import {
	ActivityIndicator,
	ScrollView,
	StyleSheet,
	Text,
	TouchableOpacity,
	View,
} from 'react-native'
import FastImage from 'react-native-fast-image'
import { useSafeAreaInsets } from 'react-native-safe-area-context'
import { useActiveTrack } from 'react-native-track-player'

const PlayerScreen = () => {
	const activeTrack = useActiveTrack()
	const { imageColors, readablePrimaryColor } = usePlayerBackground(
		activeTrack?.artwork ?? require('@/assets/unknown_track.png'),
	)

	const { top } = useSafeAreaInsets()

	const { isFavorite, toggleFavorite } = useTrackPlayerFavorite()

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
				imageColors && imageColors.secondary && imageColors.detail
					? [imageColors.secondary, imageColors.detail]
					: [colors.background, colors.backgroundDarker]
			}
		>
			<View style={[styles.overlayContainer]}>
				{/* <DismissPlayerSymbol /> */}
				<ScrollView
					style={[styles.scrollContainer, { marginTop: top + 24 }]}
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
											<TouchableOpacity activeOpacity={0.7} onPress={toggleFavorite}>
												<FontAwesome
													name={isFavorite ? 'heart' : 'heart-o'}
													size={28}
													color={isFavorite ? colors.primary : colors.icon}
													style={{ marginHorizontal: 14 }}
												/>
											</TouchableOpacity>
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

									<View
										style={{
											flexDirection: 'row',
											justifyContent: 'flex-end',
											gap: 36,
										}}
									>
										<ShareButton recording_id={activeTrack.id} />
										<Link href="/queue" asChild>
											<MaterialIcons name="queue-music" size={30} color="white" />
										</Link>
									</View>
								</View>
							</View>
						</View>
						{activeTrack.lyrics && (
							<View
								style={[
									{
										backgroundColor: readablePrimaryColor,
									},
									styles.lyricsContainer,
								]}
							>
								<Text style={styles.lyricsHeader}>Lyrics</Text>
								<Text style={styles.lyricsText}>{activeTrack.lyrics}</Text>
							</View>
						)}
					</View>
				</ScrollView>
			</View>
		</LinearGradient>
	)
}

const DismissPlayerSymbol = () => {
	const { top } = useSafeAreaInsets()

	return (
		<View
			style={{
				position: 'absolute',
				top: top + 8,
				left: 0,
				right: 0,
				flexDirection: 'row',
				justifyContent: 'center',
			}}
		>
			<View
				accessible={false}
				style={{
					width: 50,
					height: 8,
					borderRadius: 8,
					backgroundColor: '#fff',
					opacity: 0.7,
				}}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
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
		paddingTop: 12,
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
