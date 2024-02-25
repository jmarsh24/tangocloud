import React from 'react';
import { Text, View, StyleSheet, FlatList, Pressable, Image} from 'react-native'; 
import { useTheme } from '@react-navigation/native';
import { GET_HOME_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import TrackPlayer from 'react-native-track-player';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function Page() {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(GET_HOME_PLAYLISTS, {
    variables: { first: 20 }
  });

  // Check for loading and error states first
  if (loading) return <View style={styles.container}><Text>Loading playlists...</Text></View>;
  if (error) return <View style={styles.container}><Text>Error loading playlists.</Text></View>;

  // Safely access getHomePlaylists, ensuring it's not null
  const playlists = data?.getHomePlaylists?.edges.map(edge => edge.node) || [];

  async function loadTracks(playlists) {
  const tracks = playlists.flatMap(playlist =>
    playlist.playlistAudioTransfers.flatMap(transfer => {
      if (!transfer.audioTransfer.audioVariants.length) return []; // Skip if no audio variants
      return {
        id: transfer.audioTransfer.id,
        url: transfer.audioTransfer.audioVariants[0]?.audioFileUrl,
        title: playlist.title,
        artist: playlist.user.username,
        artwork: transfer.audioTransfer.album?.albumArtUrl, // Check if album exists
        duration: transfer.audioTransfer.audioVariants[0]?.duration,
      };
    })
  ).filter(Boolean); // Remove any undefined or null entries

  try {
    await TrackPlayer.reset();
    await TrackPlayer.add(tracks);
  } catch (e) {
    console.error('Error loading tracks: ', e);
  }
}

  async function handlePlaylistPress(playlist) {
  console.log('Playlist pressed: ', playlist.title);
  console.log('Playlist tracks: ', playlist.playlistAudioTransfers);

  const tracks = playlist.playlistAudioTransfers.flatMap(transfer => {
    if (!transfer.audioTransfer.audioVariants.length) return []; // Skip if audioVariants is empty or null
    return {
      id: transfer.audioTransfer.id,
      url: transfer.audioTransfer.audioVariants[0]?.audioFileUrl, // Use optional chaining
      title: transfer.audioTransfer.recording?.title,
      artist: transfer.audioTransfer.recording?.orchestra?.name, // Use optional chaining in case `orchestra` is null
      artwork: transfer.audioTransfer.album?.albumArtUrl, // Use optional chaining
      duration: transfer.audioTransfer.audioVariants[0]?.duration, // Use optional chaining
    };
  }).filter(Boolean); // Remove any undefined entries resulting from the map

  console.log('Tracks: ', tracks);
  try {
    console.log('Adding tracks to queue');
    await TrackPlayer.reset(); // Clears the current queue
    await TrackPlayer.add(tracks); // Adds tracks to the queue
    await TrackPlayer.play(); // Starts playback
  } catch (e) {
    console.error('Error enqueuing tracks: ', e);
  }
}

  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
      <FlatList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <Pressable onPress={() => handlePlaylistPress(item)}>
            <View style={styles.playlistContainer}>
              <Image source={{ uri: item.imageUrl }} style={styles.playlistImage} />
              <View style={{ flex: 1 }}>
                <Text style={[styles.playlistTitle, { color: colors.text }]}>{item.title}</Text>
              </View>
            </View>
          </Pressable>
        )}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 10,
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingHorizontal: 20,
    marginBottom: 20,
  },
  playlistContainer: {
    display: 'flex',
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#cccccc',
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  playlistDescription: {
    fontSize: 14,
  },
  playlistImage: {
    width: 100,
    height: 100,
  }
});
