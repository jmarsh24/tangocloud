import React, { useEffect } from "react";
import { View, Text, Image, StyleSheet, ActivityIndicator } from "react-native";
import { useLocalSearchParams } from "expo-router";
import { useTheme } from "@react-navigation/native";
import { useQuery } from "@apollo/client";
import { FlashList } from "@shopify/flash-list";
import TrackListItem from "@/components/TrackListItem";
import { FETCH_SINGER } from "@/graphql";
import { SafeAreaView } from "react-native-safe-area-context";

export default function SingerScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const { colors } = useTheme();

  const { data, loading, error } = useQuery(FETCH_SINGER, { variables: { id } });

  useEffect(() => {
    if (error) {
      console.error("Error fetching singer:", error);
    }
  }, [error]);

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" />
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView style={styles.container}>
        <Text>Error loading singer.</Text>
      </SafeAreaView>
    );
  }

  const singer = data?.fetchSinger;

  const recordings = singer.recordings.edges.map(({ node: item }) => ({
    id: item.id,
    title: item.title,
    artist: item.orchestra ? item.orchestra.name : "Unknown",
    duration: item.audioTransfers[0]?.audioVariants[0]?.duration || 0,
    artwork: item.audioTransfers[0]?.album?.albumArtUrl,
    url: item.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
    year: item.year,
    genre: item.genre.name,
    singer: item.singers[0]?.name,
  }));

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.imageContainer}>
        {singer.photoUrl && (
          <Image source={{ uri: singer.photoUrl }} style={styles.image} />
        )}
        <Text style={[styles.title, { color: colors.text }]}>
          {singer.name}
        </Text>
      </View>
      <FlashList
        data={recordings}
        renderItem={({ item }) => <TrackListItem track={item} />}
        keyExtractor={(item) => item.id.toString()}
        estimatedItemSize={80}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  imageContainer: {
    alignItems: 'center',
    marginBottom: 20,
  },
  image: {
    width: "100%",
    height: 200,
    position: "relative",
  },
  title: {
    position: "absolute",
    bottom: 0,
    left: 0,
    fontSize: 24,
    fontWeight: "bold",
    textAlign: "center",
    paddingLeft: 10,
    paddingBottom: 10,
  },
});
