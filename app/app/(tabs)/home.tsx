import React, { useState } from 'react';
import { Text, View, StyleSheet, FlatList, Pressable, Image } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { PLAYLISTS, PLAYLIST } from '@/graphql'; // Ensure these are correctly imported
import { useQuery } from '@apollo/client';
import TrackPlayer from 'react-native-track-player';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function HomeScreen() {
  const { colors } = useTheme();
  const [selectedPlaylistId, setSelectedPlaylistId] = useState(null);

  // Query for fetching the list of playlists
  const {
    data: playlistsData,
    loading: playlistsLoading,
    error: playlistsError,
  } = useQuery(PLAYLISTS, { variables: { first: 20 } });

  // Query for fetching the contents of a selected playlist
  const {
    data: playlistData,
    loading: playlistLoading,
    error: playlistError,
  } = useQuery(PLAYLIST, {
    variables: { Id: selectedPlaylistId },
    skip: !selectedPlaylistId, // Skip this query until a playlist is selected
  });

  if (playlistsLoading) return <View style={styles.container}><Text>Loading playlists...</Text></View>;
  if (playlistsError) return <View style={styles.container}><Text>Error loading playlists.</Text></View>;

  const playlists = playlistsData?.playlists?.edges.map(edge => edge.node) || [];

  async function handlePlaylistPress(playlistId) {
    setSelectedPlaylistId(playlistId);
  }

  // This effect could be used to trigger playback once playlist details are fetched
  React.useEffect(() => {
    const loadTracksToPlayer = async () => {
      console.log('loadtrackstoplayer', playlistData, playlistData.playlist)
      if (playlistData && playlistData.playlist) {
        console.log('Playlist data:', playlistData.playlist);

        // Your logic to handle the playlist data and load tracks into TrackPlayer
      }
    };

    loadTracksToPlayer();
  }, [playlistData]);

  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
      <FlatList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <Pressable onPress={() => handlePlaylistPress(item.id)}>
            <View style={styles.playlistContainer}>
              <Image source={{ uri: item.imageUrl }} style={styles.playlistImage} />
              <View style={styles.playlistInfo}>
                <Text style={[styles.playlistTitle, { color: colors.text }]}>{item.title}</Text>
                <Text style={[styles.playlistDescription, { color: colors.text }]}>{item.description}</Text>
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
