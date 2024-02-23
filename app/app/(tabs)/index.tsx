import React from 'react';
import { Text, View, StyleSheet, FlatList, Pressable, Image} from 'react-native'; // Corrected 'FlatList'
import { useTheme } from '@react-navigation/native';
import { GET_HOME_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import TrackPlayer from 'react-native-track-player';

export default function Page() {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(GET_HOME_PLAYLISTS, {
    variables: { first: 20 },
    fetchPolicy: 'cache-and-network',
  });

  // Check for loading and error states first
  if (loading) return <View style={styles.container}><Text>Loading playlists...</Text></View>;
  if (error) return <View style={styles.container}><Text>Error loading playlists.</Text></View>;

  // Safely access getHomePlaylists, ensuring it's not null
  const playlists = data?.getHomePlaylists?.edges.map(edge => edge.node) || [];

  async function loadTracks(playlists) {
    const tracks = playlists.flatMap(playlist => 
        playlist.playlistAudioTransfers.map(transfer => ({
            id: transfer.audioTransfer.id, // Unique ID for the track
            url: transfer.audioTransfer.audioVariants[0].audioFileUrl, // URL to the audio file
            title: playlist.title, // Title of the track
            artist: playlist.user.username, // Artist name
            artwork: transfer.audioTransfer.album.albumArtUrl // URL to the album art
        }))
    );

    try {
        await TrackPlayer.reset(); // Clear the current track list
        await TrackPlayer.add(tracks); // Add new tracks
    } catch (e) {
        console.error('Error loading tracks: ', e);
    }
  }

  async function handlePlaylistPress(playlist) {
    console.log('Playlist pressed: ', playlist.title);
    console.log('Playlist tracks: ', playlist.playlistAudioTransfers)

    const tracks = playlist.playlistAudioTransfers.map(transfer => ({
      id: transfer.audioTransfer.id,
      url: transfer.audioTransfer.audioVariants[0].audioFileUrl,
      title: transfer.audioTransfer.recording.title,
      artist: transfer.audioTransfer.recording.orchestra.name,
      artwork: transfer.audioTransfer.album.albumArtUrl,
      duration: transfer.audioTransfer.audioVariants[0].duration,
    }));
    console.log('Tracks: ', tracks)
    try {
      console.log('Adding tracks to queue')
      await TrackPlayer.reset(); // Clears the current queue
      await TrackPlayer.add(tracks); // Adds tracks to the queue
      await TrackPlayer.play(); // Starts playback
    } catch (e) {
      console.error('Error enqueuing tracks: ', e);
    }
  }

  return (
    <View style={styles.container}>
      <FlatList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <Pressable onPress={() => handlePlaylistPress(item)}>
            <View style={styles.playlistContainer}>
              <Image source={{ uri: item.imageUrl }} style={styles.playlistImage} />
              <View style={{ flex: 1 }}>
                <Text style={[styles.playlistTitle, { color: colors.text }]}>{item.title}</Text>
                <Text style={[styles.playlistDescription, { color: colors.text }]}>{item.description}</Text>
              </View>
            </View>
          </Pressable>
        )}
      />
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
    </View>
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
