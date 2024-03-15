import React, { useEffect } from "react";
import { View, Text, StyleSheet, ActivityIndicator } from "react-native";
import { useLocalSearchParams } from "expo-router";
import { useTheme } from "@react-navigation/native";
import { useQuery } from "@apollo/client";
import { FlashList } from "@shopify/flash-list";
import { FETCH_PLAYLIST } from "@/graphql";
import TrackListItem from "@/components/TrackListItem";
import { SafeAreaView } from "react-native-safe-area-context";

export default function PlaylistScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useTheme();

  const { data, loading, error } = useQuery(FETCH_PLAYLIST, {variables: { id } });

  useEffect(() => {
    if (error) {
      console.error("Error fetching playlist:", error);
    }
  }, [error]);

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color={colors.primary} />
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <Text style={[styles.errorText, { color: colors.text }]}>
          Error loading playlist.
        </Text>
      </View>
    );
  }
  const playlist = data?.fetchPlaylist;
  const recordings = playlist.playlistItems.map((item) => {
      const recording = item.playable;
      return {
        id: recording.id,
        title: recording.title,
        artist: recording.orchestra?.name || "Unknown Artist",
        duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
        artwork: recording.audioTransfers[0]?.album?.albumArtUrl || "",
        url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || "",
      };
    });

  return (
    <SafeAreaView style={{ padding: 10, gap: 20, flex: 1 }}>
      <Text style={[styles.title, { color: colors.text }]}>
        {playlist.title}
      </Text>
      <FlashList
        data={recordings}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => <TrackListItem track={item} />}
        estimatedItemSize={80}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
  },
  loadingContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  title: {
    fontSize: 24,
    fontWeight: "bold",
    marginHorizontal: 16,
    marginTop: 16,
  },
  errorText: {
    fontSize: 16,
    textAlign: "center",
    marginTop: 16,
  },
});
