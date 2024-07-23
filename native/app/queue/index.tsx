import { PlayerControls } from '@/components/PlayerControls'
import SimpleProgressBar from '@/components/SimpleProgressBar'
import { colors, screenPadding } from '@/constants/tokens'
import { joinAttributes } from '@/helpers/miscellaneous'
import { defaultStyles } from '@/styles'
import React, { useEffect, useState } from 'react'
import { ScrollView, StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import TrackPlayer from 'react-native-track-player'

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
				<Text style={styles.header}>Now Playing</Text>
				{currentTrackIndex !== null && (
					<View style={styles.nowPlayingContainer}>
						<FastImage source={{ uri: currentTrack.artwork }} style={styles.trackArtworkImage} />
						<View style={styles.trackInfoContainer}>
							<Text style={styles.trackTitleNowPlaying}>{currentTrack.title}</Text>
							<Text style={styles.trackDetails}>{`${joinAttributes([
								currentTrack.artist,
								currentTrack.singer,
							])}`}</Text>
						</View>
					</View>
				)}

				<Text style={styles.header}>Up Next</Text>
				<View style={styles.tracksContainer}>
					{queue.length > 1 ? (
						queue.map(
							(track, index) =>
								index !== currentTrackIndex && (
									<View key={index} style={[styles.trackInfoContainer]}>
										<Text style={styles.trackTitle}>{track.title}</Text>
										<Text
											style={styles.trackDetails}
										>{`${joinAttributes([track.artist, track.singer])}`}</Text>
									</View>
								),
						)
					) : (
						<Text style={styles.emptyQueueText}>Queue is empty</Text>
					)}
				</View>
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
})

export default QueueScreen
