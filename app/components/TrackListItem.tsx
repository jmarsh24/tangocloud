import React from 'react';
import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import { useMutation, useLazyQuery } from '@apollo/client';
import { CREATE_PLAYBACK, FETCH_RECORDING_URL } from "@/graphql";

export default function TrackListItem({ track }) {
  const { colors } = useTheme();
  const [createPlayback] = useMutation(CREATE_PLAYBACK);
  const [fetchRecordingURL, { data }] = useLazyQuery(FETCH_RECORDING_URL, {
    variables: { id: track.id },
    fetchPolicy: "network-only"
  });

  const onTrackPress = async () => {
    await fetchRecordingURL();
    try {
      if (data) {
        const audioFileUrl = data.fetchRecording.audioTransfers[0].audioVariants[0].audioFileUrl;
        const trackForPlayer = {
          id: track.id,
          url: audioFileUrl,
          title: track.title,
          artist: track.artist,
          artwork: track.artwork,
          duration: track.duration,
        };

        await createPlayback({
          variables: {
            recordingId: track.id,
          },
        });

        await TrackPlayer.reset();
        await TrackPlayer.add([trackForPlayer]);
        await TrackPlayer.play();
      }
    } catch (error) {
      console.error('Error fetching URL or playing track:', error);
    }
  };

  return (
    <Pressable onPress={onTrackPress} style={styles.songCard}>
      <Image source={{ uri: track.artwork }} style={styles.songAlbumArt} />
      <View style={styles.songTextContainer}>
        <Text style={[styles.songTitle, { color: colors.text }]}>{track.title}</Text>
        <Text style={[styles.songDetails, { color: colors.text }]}>{[track.artist, track.singer].filter(Boolean).join(' • ')}</Text>
        <Text style={[styles.songDetails, { color: colors.text }]}>{[track.genre, track.year].filter(Boolean).join(' • ')}</Text>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  songCard: {
    flex: 1,
    flexDirection: "row",
    paddingVertical: 10,
    paddingHorizontal: 10,
    borderRadius: 8,
  },
  songAlbumArt: {
    width: 56,
    height: 56,
    aspectRatio: 1,
    borderRadius: 5,
  },
  songTitle: {
    fontWeight: "bold",
    fontSize: 16,
    marginLeft: 10,
  },
  songDetails: {
    fontSize: 14,
    marginLeft: 10,
  },
  songTextContainer: {
    flexDirection: "column",
  },
  loadingText: {
    fontSize: 14,
    marginLeft: 10,
  },
  errorText: {
    fontSize: 14,
    color: 'red',
    marginLeft: 10,
  },
});