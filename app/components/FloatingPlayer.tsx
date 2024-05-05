import { PlayPauseButton, SkipToNextButton } from '@/components/PlayerControls'
import { joinAttributes } from '@/helpers/miscellaneous'
import { useLastActiveTrack } from '@/hooks/useLastActiveTrack'
import { usePlayerBackground } from '@/hooks/usePlayerBackground'
import { defaultStyles } from '@/styles'
import { useRouter } from 'expo-router'
import { StyleSheet, TouchableOpacity, View, ViewProps } from 'react-native'
import FastImage from 'react-native-fast-image'
import { useActiveTrack } from 'react-native-track-player'
import { MovingText } from './MovingText'
import SimpleProgressBar from './SimpleProgressBar'

export const FloatingPlayer = ({ style }: ViewProps) => {
	const router = useRouter()

	const activeTrack = useActiveTrack()
	const lastActiveTrack = useLastActiveTrack()

	const displayedTrack = activeTrack ?? lastActiveTrack

	const { imageColors, readablePrimaryColor } = usePlayerBackground(
		activeTrack?.artwork ?? require('@/assets/unknown_track.png'),
	)

	const handlePress = () => {
		router.navigate('/player')
	}

	if (!displayedTrack) return null

	const extraInfo = `${joinAttributes([displayedTrack.artist, displayedTrack.singer, displayedTrack.year])}`

	return (
		<TouchableOpacity
			onPress={handlePress}
			activeOpacity={1}
			style={[styles.container, style, { backgroundColor: readablePrimaryColor }]}
		>
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
			<View style={styles.progressBar}>
				<SimpleProgressBar />
			</View>
		</TouchableOpacity>
	)
}

const styles = StyleSheet.create({
	container: {
		flexDirection: 'row',
		alignItems: 'center',
		backgroundColor: '#252525',
		padding: 8,
		borderRadius: 12,
		paddingVertical: 10,
		position: 'relative',
	},
	trackArtworkImage: {
		width: 40,
		height: 40,
		borderRadius: 8,
	},
	trackDetailsContainer: {
		flex: 1,
		marginLeft: 10,
		marginRight: 10,
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
		color: '#ccc',
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
