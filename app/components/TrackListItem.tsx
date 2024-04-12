import React from 'react';
import { Text, View, StyleSheet, Image, Pressable, Alert } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import { useMutation, useLazyQuery } from '@apollo/client';
import { CREATE_PLAYBACK, FETCH_RECORDING_URL } from "@/graphql";

export default function TrackListItem({ track }) {
  const { colors } = useTheme();
  const [createPlayback] = useMutation(CREATE_PLAYBACK);
  const [fetchRecordingURL, { data, called, loading, error }] = useLazyQuery(FETCH_RECORDING_URL, {
    variables: { id: track.id },
    fetchPolicy: "network-only"
  });

  const onTrackPress = async () => {
    try {
      // Call to fetch the recording URL and wait for response
      const response = await fetchRecordingURL();
      if (response && response.data) {
        const audioFileUrl = response.data.fetchRecording.audioTransfers[0].audioVariants[0].audioFileUrl;
        const trackForPlayer = {
          id: track.id,
          url: audioFileUrl,
          title: track.title,
          artist: track.artist,
          artwork: track.artwork,
          duration: track.duration,
        };

        // Create playback record
        await createPlayback({
          variables: {
            recordingId: track.id,
          },
        });

        // Setup track player
        await TrackPlayer.reset();
        await TrackPlayer.add([trackForPlayer]);
        await TrackPlayer.play();
      }
    } catch (err) {
      console.error('Error fetching URL or playing track:', err);
      Alert.alert("Playback Error", "Unable to play the track. Please try again.");
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
});