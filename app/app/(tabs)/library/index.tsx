import React, { useCallback } from 'react';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import { useQuery } from '@apollo/client';
import { FETCH_LIKED_RECORDINGS } from '@/graphql';
import TrackListItem from '@/components/TrackListItem';
import { FlashList } from "@shopify/flash-list";
import { useFocusEffect } from '@react-navigation/native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@react-navigation/native';
import { debug } from 'console';

export default function LibrarysScreen() {
  const { colors } = useTheme();
  const { data: recordings, loading, error, refetch } = useQuery(FETCH_LIKED_RECORDINGS);

  useFocusEffect(
    useCallback(() => {
      refetch();
    }, [refetch])
  );

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  if (!recordings?.fetchLikedRecordings) {
    return <Text>No liked recordings</Text>;
  }

  const tracks = recordings?.fetchLikedRecordings.edges.map(edge => ({
    id: edge.node.id,
    title: edge.node.title,
    artist: edge.node.orchestra.name,
    duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
    artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || "",
    url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || "",
    genre: edge.node.genre.name,
    year: edge.node.year,
    singer: edge.node.singers[0]?.name,
  })) || [];

  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.title, { color: colors.text }]}>
        Liked Recordings
      </Text>
      <FlashList
          data={tracks}
          renderItem={({ item }) => <TrackListItem track={item} />}
          ItemSeparatorComponent={() => <View style={styles.itemSeparator} />}
          estimatedItemSize={75}
        />
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
    fontWeight: "bold",
    alignSelf: "center",
    marginVertical: 10
  },
  itemSeparator: {
    height: 1,
  },
});
