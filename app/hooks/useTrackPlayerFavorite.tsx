import { useApolloClient, useMutation, useQuery } from '@apollo/client'
import { useCallback } from 'react'
import { useActiveTrack } from 'react-native-track-player'

import {
	ADD_LIKE_TO_RECORDING,
	CHECK_LIKE_STATUS_ON_RECORDING,
	FETCH_LIKED_RECORDINGS,
	REMOVE_LIKE_FROM_RECORDING,
} from '@/graphql'

export const useTrackPlayerFavorite = () => {
	const activeTrack = useActiveTrack()
	const client = useApolloClient()

	const {
		data,
		loading: statusLoading,
		error: statusError,
		refetch,
	} = useQuery(CHECK_LIKE_STATUS_ON_RECORDING, {
		variables: { recordingId: activeTrack?.id },
		fetchPolicy: 'network-only',
	})

	const isFavorite = data?.checkLikeStatusOnRecording

	const [addLikeToRecording, { loading: adding, error: addError }] = useMutation(
		ADD_LIKE_TO_RECORDING,
		{
			onCompleted: () => {
				refetch()
				refetchLikedRecordings() // Refetch the list of liked recordings
			},
		},
	)
	const [removeLikeFromRecording, { loading: removing, error: removeError }] = useMutation(
		REMOVE_LIKE_FROM_RECORDING,
		{
			onCompleted: () => {
				refetch()
				refetchLikedRecordings() // Refetch the list of liked recordings
			},
		},
	)

	const refetchLikedRecordings = useCallback(() => {
		client.refetchQueries({
			include: [FETCH_LIKED_RECORDINGS],
		})
	}, [client])

	const toggleFavorite = useCallback(async () => {
		if (!activeTrack) return // Do nothing if there is no active track

		const mutation = isFavorite ? removeLikeFromRecording : addLikeToRecording
		await mutation({ variables: { recordingId: activeTrack.id } })
	}, [isFavorite, activeTrack, addLikeToRecording, removeLikeFromRecording])

	return {
		isFavorite,
		toggleFavorite,
		loading: adding || removing || statusLoading,
		error: addError || removeError || statusError,
	}
}
