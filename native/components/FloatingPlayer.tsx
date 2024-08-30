import { PlayPauseButton, SkipToNextButton } from '@/components/PlayerControls'
import { joinAttributes } from '@/helpers/miscellaneous'
import { useLastActiveTrack } from '@/hooks/useLastActiveTrack'
import { usePlayerBackground } from '@/hooks/usePlayerBackground'
import { defaultStyles } from '@/styles'
import { useRouter } from 'expo-router'
import { StyleSheet, TouchableOpacity, View, ViewProps, Text, ScrollView } from 'react-native'
import FastImage from 'react-native-fast-image'
import { useActiveTrack } from 'react-native-track-player'
import { MovingText } from './MovingText'
import SimpleProgressBar from './SimpleProgressBar'

export const FloatingPlayer = ({ style }: ViewProps) => {
	const router = useRouter()

	const activeTrack = useActiveTrack()
	const lastActiveTrack = useLastActiveTrack()

	const displayedTrack = activeTrack ?? lastActiveTrack

	const { readablePrimaryColor } = usePlayerBackground(
		activeTrack?.artwork ?? require('@/assets/unknown_track.png'),
	)

	const handlePress = () => {
		router.navigate('/player')
	}

	if (!displayedTrack) return null

	const extraInfo = `${joinAttributes([displayedTrack.artist, displayedTrack.singer, displayedTrack.year])}`

	// Generate list of years from 1912 to 2018
	const years = Array.from({ length: 2018 - 1912 + 1 }, (_, i) => 1912 + i)

	return (
		<View style={[styles.container, style]}>
			<View>
				<ScrollView
					horizontal
					showsHorizontalScrollIndicator={false}
					contentContainerStyle={styles.additionalInfoContainer}
				>
					{years.map((year) => (
						<View key={year} style={styles.textButton}>
							<Text style={styles.textButtonText}>{year}</Text>
						</View>
					))}
				</ScrollView>
			</View>
			<TouchableOpacity
				onPress={handlePress}
				activeOpacity={1}
				style={[styles.musicPlayer, { backgroundColor: readablePrimaryColor }]}
			>
				<View style={styles.mainContentContainer}>
					<FastImage
						source={{
							uri: displayedTrack.artwork ?? require('@/assets/unknown_track.png'),
						}}
						style={styles.trackArtworkImage}
					/>

					<View style={styles.trackDetailsContainer}>
						<MovingText
							style={styles.trackTitle}
							text={displayedTrack.title ?? ''}
							animationThreshold={25}
						/>
						<MovingText style={styles.trackInfo} text={extraInfo} animationThreshold={25} />
					</View>

					<View style={styles.trackControlsContainer}>
						<PlayPauseButton iconSize={24} />
						<SkipToNextButton iconSize={22} />
					</View>
				</View>

				<View style={styles.progressBar}>
					<SimpleProgressBar />
				</View>
			</TouchableOpacity>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flexDirection: 'column',
		backgroundColor: '#252525',
		paddingBottom: 8,
		position: 'relative',
	},
	additionalInfoContainer: {
		flexDirection: 'row',
		alignItems: 'center',
	},
	musicPlayer: {
		flexDirection: 'row',
		alignItems: 'center',
		paddingVertical: 8,
		paddingHorizontal: 10,
	},
	textButton: {
		paddingHorizontal: 12,
		paddingVertical: 6,
		borderWidth: 1,
		borderColor: 'rgba(255, 255, 255, 0.7)',
	},
	textButtonText: {
		...defaultStyles.text,
		fontSize: 12,
		color: 'rgba(255, 255, 255, 0.9)',
	},
	mainContentContainer: {
		flexDirection: 'row',
		alignItems: 'center',
	},
	trackArtworkImage: {
		width: 40,
		height: 40,
		borderRadius: 8,
	},
	trackDetailsContainer: {
		flex: 1,
		overflow: 'hidden',
	},
	trackTitle: {
		...defaultStyles.text,
		fontSize: 18,
		fontWeight: '600',
		marginBottom: 4,
	},
	trackInfo: {
		...defaultStyles.text,
		fontSize: 12,
		color: 'rgba(255, 255, 255, 0.7)',
	},
	trackControlsContainer: {
		flexDirection: 'row',
		alignItems: 'center',
		columnGap: 20,
		marginRight: 16,
		paddingLeft: 16,
	},
	progressBar: {
		position: 'absolute',
		bottom: 0,
		left: 15,
		right: 15,
	},
})
