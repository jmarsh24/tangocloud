import React, { useEffect } from "react";
import { View, Text, StyleSheet, ActivityIndicator } from "react-native";
import { useLocalSearchParams, Stack } from "expo-router";
import { useTheme } from "@react-navigation/native";
import { useQuery } from "@apollo/client";
import { FlashList } from "@shopify/flash-list";
import TrackListItem from "@/components/TrackListItem";
import { FETCH_LYRICIST } from "@/graphql";
import { SafeAreaView } from "react-native-safe-area-context";

export default function LyricistScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useTheme();

  const { data, loading, error } = useQuery(FETCH_LYRICIST, { variables: { id } });

  useEffect(() => {
    if (error) {
      console.error("Error fetching lyricist:", error);
    }
  }, [error]);

  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator size="large" color={colors.primary} />
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <Text>Error loading lyricist.</Text>
      </View>
    );
  }

  const recordings = data?.fetchLyricist.compositions.edges.flatMap(({ node: composition }) =>
    composition.recordings.edges.map(({ node: recording }) => ({
      id: recording.id,
      title: recording.title,
      artist: data.fetchLyricist.name,
      duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
      artwork: recording.audioTransfers[0]?.album?.albumArtUrl,
      url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
      year: recording.year,
      genre: recording.genre.name,
      singer: recording.singers[0]?.name,
    }))
  );

  return (
    <SafeAreaView style={styles.container}>
      <Stack.Screen options={{ title: data.fetchLyricist.name }} />
      <Text style={[styles.title, { color: colors.text }]}>
        {data.fetchLyricist.name}
      </Text>
      {recordings && recordings.length > 0 ? (
        <FlashList
          data={recordings}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => <TrackListItem track={item}  tracks={recordings} />}
          estimatedItemSize={80}
        />
      ) : (
        <Text>No recordings found.</Text>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 10,
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
    fontWeight: "bold",
  },
});
