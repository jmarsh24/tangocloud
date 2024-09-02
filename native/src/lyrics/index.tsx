import { PlayerControls } from '@/components/PlayerControls'
import SimpleProgressBar from '@/components/SimpleProgressBar'
import { colors, screenPadding } from '@/constants/tokens'
import { defaultStyles } from '@/styles'
import React, { useEffect, useState } from 'react'
import { ScrollView, StyleSheet, Text, View } from 'react-native'
import TrackPlayer from 'react-native-track-player'
import { fontSize } from '@/constants/tokens'
import { joinAttributes } from '@/helpers/miscellaneous'

const QueueScreen = () => {
	const [queue, setQueue] = useState([])
	const [currentTrackIndex, setCurrentTrackIndex] = useState(null)

	useEffect(() => {
		const fetchQueueAndCurrentTrack = async () => {
			const queueData = await TrackPlayer.getQueue()
			const currentTrack = await TrackPlayer.getActiveTrackIndex()
			setQueue(queueData)
			setCurrentTrackIndex(currentTrack)
		}

		fetchQueueAndCurrentTrack()
	}, [])

	const currentTrack = queue[currentTrackIndex] || {}

	return (
		<View style={defaultStyles.container}>
			<ScrollView
				style={[
					defaultStyles.container,
					{ paddingVertical: 24, paddingHorizontal: screenPadding.horizontal },
				]}
			>
				<Text style={styles.header}>
					{currentTrack.title}
				</Text>
				<Text style={styles.lyricsText}>
					{currentTrack.lyrics}
				</Text>
			</ScrollView>
			<View style={{ paddingVertical: 48 }}>
				<View style={styles.progressBar}>
					<SimpleProgressBar />
				</View>
				<PlayerControls />
			</View>
		</View>
	)
}

const styles = StyleSheet.create({
	nowPlayingContainer: {
		flexDirection: 'row',
		gap: 10,
		paddingVertical: 20,
	},
	trackArtworkImage: {
		width: 56,
		height: 56,
		borderRadius: 8,
	},
	header: {
		color: 'white',
		fontSize: 16,
		fontWeight: 'bold',
		marginBottom: 10,
	},
	trackInfoContainer: {
		paddingVertical: 10,
	},
	trackTitle: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 14,
	},
	trackTitleNowPlaying: {
		color: colors.primary,
		fontWeight: 'bold',
		fontSize: 16,
	},
	trackDetails: {
		color: 'rgba(255, 255, 255, 0.7)',
		fontSize: 12,
	},
	emptyQueueText: {
		color: 'white',
		textAlign: 'center',
		marginTop: 20,
	},
	progressBar: {
		position: 'absolute',
		top: 0,
		left: 0,
		right: 0,
	},
		lyricsText: {
		...defaultStyles.textLyrics,
		fontSize: fontSize.lg,
		fontWeight: '700',
	},
})

export default QueueScreen
