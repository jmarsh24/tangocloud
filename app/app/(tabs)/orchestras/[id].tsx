import React, { useEffect } from "react";
import { View, Text, StyleSheet, ActivityIndicator } from "react-native";
import { useLocalSearchParams } from "expo-router";
import { useTheme } from "@react-navigation/native";
import { useQuery } from "@apollo/client";
import { FlashList } from "@shopify/flash-list";
import TrackListItem from "@/components/TrackListItem";
import { FETCH_ORCHESTRA } from "@/graphql";
import { SafeAreaView } from "react-native-safe-area-context";

export default function OrchestraScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useTheme();

  const { data, loading, error } = useQuery(FETCH_ORCHESTRA, { variables: { id } });

  useEffect(() => {
    if (error) {
      console.error("Error fetching orchestra:", error);
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
        <Text>Error loading orchestra.</Text>
      </View>
    );
  }
  const orchestra = data?.fetchOrchestra;

  const recordings = orchestra.recordings.edges.map(({ node: item }) => ({
    id: item.id,
    title: item.title,
    artist: orchestra.name,
    duration: item.audioTransfers[0]?.audioVariants[0]?.duration || 0,
    artwork: item.audioTransfers[0]?.album?.albumArtUrl,
    url: item.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
    genre: item.genre.name,
    year: item.year,
  }));

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>
        {orchestra.name}
      </Text>
      <FlashList
        data={recordings}
        renderItem={({ item }) => <TrackListItem track={item} />}
        estimatedItemSize={80}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    paddingHorizontal: 10,
  },
  title: {
    fontSize: 24,
    marginBottom: 20,
  },
});
