import React, { useState, useEffect } from "react";
import { Text, View, StyleSheet, FlatList, Image, ActivityIndicator } from "react-native";
import { useTheme } from "@react-navigation/native";
import { SEARCH_PLAYLISTS, FETCH_PLAYLIST } from "@/graphql";
import { useQuery, useLazyQuery } from "@apollo/client";
import TrackPlayer from "react-native-track-player";
import { SafeAreaView } from "react-native-safe-area-context";
import { Link } from "expo-router"

export default function HomeScreen() {
  const { colors } = useTheme();
  const [selectedPlaylistId, setSelectedPlaylistId] = useState(null);
  const [isLoadingTracks, setIsLoadingTracks] = useState(false);

  const {
    data: playlistsData,
    loading: playlistsLoading,
    error: playlistsError,
  } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "", first: 20 } });

  const [
    fetchPlaylist,
    { data: playlistData, loading: playlistLoading, error: playlistError },
  ] = useLazyQuery(FETCH_PLAYLIST);

  useEffect(() => {
    if (playlistsError) {
      console.log("Error fetching playlists:", playlistsError);
    }
  }, [playlistsError]);

  useEffect(() => {
    if (playlistError) {
      console.log("Selected Playlist ID:", selectedPlaylistId);
      console.log("Error fetching playlist:", playlistError);
    }
  }, [playlistError]);

  useEffect(() => {
    const loadTracksToPlayer = async () => {
      if (playlistData && playlistData.playlist) {
        setIsLoadingTracks(true);
        try {
          const tracks = playlistData.playlist.playlistAudioTransfers
            .map((transfer) => {
              // Ensure every required field is present and valid
              if (!transfer.audioTransfer.audioVariants.length) return null;
              const variant = transfer.audioTransfer.audioVariants[0];
              if (!variant.audioFileUrl || !variant.duration) return null;
              return {
                id: transfer.audioTransfer.id.toString(), // Ensure 'id' is a string
                url: variant.audioFileUrl,
                title:
                  transfer.audioTransfer.recording?.title || "Unknown Title", // Provide default values
                artist:
                  transfer.audioTransfer.recording?.orchestra?.name ||
                  "Unknown Artist",
                artwork: transfer.audioTransfer.album?.albumArtUrl || "", // Provide a default or empty string
                duration: variant.duration,
              };
            })
            .filter((track) => track !== null); // Remove any null entries

          if (tracks.length > 0) {
            await TrackPlayer.reset();
            await TrackPlayer.add(tracks);
            await TrackPlayer.play();
          } else {
            console.log("No valid tracks to load");
          }
        } catch (error) {
          console.error("Error loading tracks into TrackPlayer:", error);
        } finally {
          setIsLoadingTracks(false);
        }
      }
    };

    if (playlistData && !isLoadingTracks) {
      loadTracksToPlayer();
    }
  }, [playlistData]);

  if (playlistsLoading)
    return (
      <View style={styles.container}>
        <Text>Loading playlists...</Text>
      </View>
    );
  if (playlistsError)
    return (
      <View style={styles.container}>
        <Text>Error loading playlists.</Text>
      </View>
    );

  const playlists = playlistsData?.searchPlaylists?.edges.map(
    (edge) => edge.node
  );

  const handlePlaylistPress = (playlistId) => {
    console.log("handlePlaylistPress", playlistId);
    setSelectedPlaylistId(playlistId);
    fetchPlaylist({ variables: { id: playlistId } });
  };

  const renderPlaylistItem = ({ item }) => (
    <Link href={{ pathname: "/playlists/[id]", params: { id: item.id } }}>
      <View style={styles.playlistContainer}>
        <Image source={{ uri: item.imageUrl }} style={styles.playlistImage} />
        <View style={styles.playlistInfo}>
          <Text style={[styles.playlistTitle, { color: colors.text }]}>
            {item.title}
          </Text>
        </View>
        {selectedPlaylistId === item.id && (isLoadingTracks || playlistLoading) && (
          <ActivityIndicator size="small" color={colors.primary} />
        )}
      </View>
    </Link>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are
        the ones who do.
      </Text>
      <FlatList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={renderPlaylistItem}
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
    fontWeight: "bold",
    textAlign: "center",
    paddingHorizontal: 20,
    paddingVertical: 20,
  },
  playlistContainer: {
    display: "flex",
    flexDirection: "row",
    gap: 10,
    alignItems: "center",
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: "#cccccc",
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: "bold",
  },
  playlistDescription: {
    fontSize: 14,
  },
  playlistImage: {
    width: 100,
    height: 100,
  },
});
