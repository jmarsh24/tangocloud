import { View, Text, ActivityIndicator } from 'react-native';
import { useQuery } from '@apollo/client';
import { FETCH_LIKED_RECORDINGS } from '@/graphql';
import TrackListItem from '@/components/TrackListItem';
import { FlashList } from "@shopify/flash-list";
import { useFocusEffect } from '@react-navigation/native';
import { useCallback } from 'react';

export default function LibrarysScreen() {
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
  })) || [];
  
  return (
    <FlashList
        data={tracks}
        renderItem={({ item }) => <TrackListItem track={item} />}
        ItemSeparatorComponent={() => <View style={styles.itemSeparator} />}
        estimatedItemSize={75}
      />
  );
}

const styles = {
  itemSeparator: {
    height: 2,
  },
};
