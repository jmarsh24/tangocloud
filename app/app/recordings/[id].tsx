import { FETCH_RECORDING } from '@/graphql'
import { useQueue } from '@/store/queue'
import { useQuery } from '@apollo/client'
import { router, useLocalSearchParams } from 'expo-router'
import { useEffect } from 'react'
import TrackPlayer from 'react-native-track-player'

const RecordingPage = () => {
	const { id } = useLocalSearchParams()
	const { activeQueueId, setActiveQueueId } = useQueue()

	const { data } = useQuery(FETCH_RECORDING, {
		variables: { id },
	})

	useEffect(() => {
		const loadTrack = async () => {
			if (data && data.fetchRecording) {
				const recording = data.fetchRecording
				const track = {
					id: recording.id,
					title: recording.title,
					artist: recording.orchestra.name,
					duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
					artwork: recording.audioTransfers[0]?.album?.albumArtUrl || '',
					url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
					lyrics: recording?.composition?.lyrics[0]?.content,
					genre: recording.genre.name,
					year: recording.year,
				}

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
				router.replace('/player')
			}
		}

		loadTrack()
	}, [data, id, activeQueueId, setActiveQueueId])

	return null
}

export default RecordingPage
