import React, { useEffect } from "react";
import { View, Text, StyleSheet, ActivityIndicator } from "react-native";
import { useLocalSearchParams } from "expo-router";
import { useTheme } from "@react-navigation/native";
import { useQuery } from "@apollo/client";
import { FlashList } from "@shopify/flash-list";
import TrackListItem from "@/components/TrackListItem";
import { FETCH_COMPOSER } from "@/graphql";

export default function ComposerScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useTheme();

  const { data, loading, error } = useQuery(FETCH_COMPOSER, { variables: { id: id } });

  useEffect(() => {
    if (error) {
      console.error("Error fetching composer:", error);
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
        <Text>Error loading composer.</Text>
      </View>
    );
  }

  const recordings = data?.fetchComposer.compositions.edges.flatMap(({ node: composition }) =>
    composition.recordings.edges.map(({ node: recording }) => ({
      id: recording.id,
      title: recording.title,
      artist: data.fetchComposer.name,
      duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
      artwork: recording.audioTransfers[0]?.album?.albumArtUrl,
      url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
    }))
  );

  return (
    <View style={styles.container}>
      <Text style={styles.title}>
        {data.fetchComposer.name}
      </Text>
      {recordings && recordings.length > 0 ? (
        <FlashList
          data={recordings}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => <TrackListItem track={item} />}
          estimatedItemSize={80}
        />
      ) : (
        <Text>No recordings found.</Text>
      )}
    </View>
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
  },
});
