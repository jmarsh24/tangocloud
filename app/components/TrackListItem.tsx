import React from 'react';
import { Text, View, StyleSheet, Image, Pressable, Alert } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import { useMutation } from '@apollo/client';
import { CREATE_PLAYBACK } from "@/graphql";

export default function TrackListItem({ track, tracks }) {
  const { colors } = useTheme();
  const [createPlayback] = useMutation(CREATE_PLAYBACK);

  const loadTracksToPlayer = async (selectedTrackId) => {
  try {
    await TrackPlayer.reset();
    const selectedIndex = tracks.findIndex(t => t.id === selectedTrackId);
    
    // Create a new array with the selected track as the first element
    const reorderedTracks = [
      ...tracks.slice(selectedIndex), // Tracks from the selected one to the end
      ...tracks.slice(0, selectedIndex) // Tracks from the beginning to the selected one
    ];

    const trackObjects = reorderedTracks.map(track => ({
      id: track.id,
      url: track.url,
      title: track.title,
      artist: track.artist,
      artwork: track.artwork,
      duration: track.duration,
      genre: track.genre,
      year: track.year,
      singer: track.singer,
    }));

    await TrackPlayer.add(trackObjects);
    await TrackPlayer.play();
  } catch (err) {
    console.error('Error setting up the track player:', err);
    Alert.alert("Playback Error", "There was an issue loading the tracks. Please try again.");
  }
};


  const onTrackPress = async () => {
    try {
      // Create playback record
      await createPlayback({
        variables: {
          recordingId: track.id,
        },
      });

      // Load all tracks to the player
      await loadTracksToPlayer(track.id);
    } catch (err) {
      console.error('Error during playback setup:', err);
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
