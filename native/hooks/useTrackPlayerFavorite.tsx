import { useApolloClient, useMutation, useQuery } from '@apollo/client'
import { useCallback } from 'react'
import { useActiveTrack } from 'react-native-track-player'

import {
	LIKE_RECORDING,
	RECORDING_LIKE_STATUS,
	UNLIKE_RECORDING,
	LIKED_RECORDINGS,  // Don't forget to keep importing this if it's used in refetch
} from '@/graphql'

export const useTrackPlayerFavorite = () => {
	const activeTrack = useActiveTrack()
	const client = useApolloClient()

	// Use the RECORDING_LIKE_STATUS query to fetch the like status
	const { data, loading: queryLoading, error: queryError, refetch } = useQuery(
		RECORDING_LIKE_STATUS,
		{
			variables: { recordingId: activeTrack?.id },
			skip: !activeTrack?.id,  // Skip the query if there's no active track
			fetchPolicy: 'network-only',  // Ensure fresh data each time
		}
	)

	const isFavorite = data?.recording?.likedByCurrentUser

	const [addLikeToRecording, { loading: adding, error: addError }] = useMutation(
		LIKE_RECORDING,
		{
			onCompleted: () => {
				refetch()
				refetchLikedRecordings()
			},
		}
	)

	const [removeLikeFromRecording, { loading: removing, error: removeError }] = useMutation(
		UNLIKE_RECORDING,
		{
			onCompleted: () => {
				refetch()
				refetchLikedRecordings()
			},
		}
	)

	const refetchLikedRecordings = useCallback(() => {
		client.refetchQueries({
			include: [LIKED_RECORDINGS],
		})
	}, [client])

	const toggleFavorite = useCallback(async () => {
		if (!activeTrack) return
		const mutation = isFavorite ? removeLikeFromRecording : addLikeToRecording
		await mutation({ variables: { recordingId: activeTrack.id } })
	}, [isFavorite, activeTrack, addLikeToRecording, removeLikeFromRecording])

	return {
		isFavorite,
		toggleFavorite,
		loading: adding || removing || queryLoading,
		error: addError || removeError || queryError,
	}
}
