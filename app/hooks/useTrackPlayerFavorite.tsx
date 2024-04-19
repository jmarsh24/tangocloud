import { useCallback } from 'react';
import { useActiveTrack } from 'react-native-track-player';
import { useMutation, useQuery } from '@apollo/client';
import { ADD_LIKE_TO_RECORDING, REMOVE_LIKE_FROM_RECORDING, CHECK_LIKE_STATUS_ON_RECORDING } from '@/graphql';

export const useTrackPlayerFavorite = () => {
    const activeTrack = useActiveTrack();

    const { data, loading: statusLoading, error: statusError, refetch } = useQuery(CHECK_LIKE_STATUS_ON_RECORDING, {
        variables: { recordingId: activeTrack?.id },
        fetchPolicy: 'network-only'
    });

    const isFavorite = data?.checkLikeStatusOnRecording;

    const [addLikeToRecording, { loading: adding, error: addError }] = useMutation(ADD_LIKE_TO_RECORDING, {
        onCompleted: () => refetch()  // Refetch like status after mutation
    });
    const [removeLikeFromRecording, { loading: removing, error: removeError }] = useMutation(REMOVE_LIKE_FROM_RECORDING, {
        onCompleted: () => refetch()  // Refetch like status after mutation
    });

    const toggleFavorite = useCallback(async () => {
        if (!activeTrack) return; // Do nothing if there is no active track

        const mutation = isFavorite ? removeLikeFromRecording : addLikeToRecording;
        await mutation({ variables: { recordingId: activeTrack.id } });
    }, [isFavorite, addLikeToRecording, removeLikeFromRecording, activeTrack]);

    return {
        isFavorite,
        toggleFavorite,
        loading: adding || removing || statusLoading,
        error: addError || removeError || statusError
    };
};
