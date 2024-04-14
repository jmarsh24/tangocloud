import React, { useEffect } from "react";
import { View, Text, Image, StyleSheet, ActivityIndicator } from "react-native";
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
      <SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
        <ActivityIndicator size="large" />
      </SafeAreaView>
    );
  }

  if (error) {
    return (
      <SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
        <Text>Error loading orchestra.</Text>
      </SafeAreaView>
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
    singer: item.singers[0]?.name,
  }));

  return (
    <SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
      <View style={styles.imageContainer}>
        <Image source={{ uri: orchestra.photoUrl }} style={styles.image} />
        <Text style={[styles.title, { color: colors.text }]}>
          {orchestra.name}
        </Text>
      </View>
      <FlashList
        data={recordings}
        renderItem={({ item }) => <TrackListItem track={item} tracks={recordings} />}
        keyExtractor={(item) => item.id.toString()}
        estimatedItemSize={80}
        ListFooterComponentStyle={{ paddingBottom: 80 }}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    
  },
  loadingContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
  errorContainer: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
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