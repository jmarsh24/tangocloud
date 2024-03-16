import React from 'react';
import { Text, View, StyleSheet } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { useQuery } from '@apollo/client';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_PLAYLISTS } from '@/graphql';
import PlaylistItem from '@/components/PlaylistItem';
import LikedLink from '@/components/LikedLink';
import { SafeAreaView } from 'react-native-safe-area-context';
import { styled } from 'nativewind';
const StyledView = styled(View)
const StyledText = styled(Text)

export default function HomeScreen() {
  const { colors } = useTheme();

  const {
    data: playlistsData,
    loading: playlistsLoading,
    error: playlistsError,
  } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "", first: 20 } });

  if (playlistsLoading) {
    return (
      <View style={styles.container}>
        <Text>Loading playlists...</Text>
      </View>
    );
  }

  if (playlistsError) {
    return (
      <View style={styles.container}>
        <Text>Error loading playlists.</Text>
      </View>
    );
  }

  const playlists = playlistsData?.searchPlaylists?.edges.map(edge => edge.node);

  return (
    <SafeAreaView style={styles.container}>
      <View className="flex-1 items-center justify-center">
        <Text className="text-red-800">Styling just works! 🎉</Text>
      </View>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
      <FlashList
        data={playlists}
        keyExtractor={(item) => item.id}
        ListHeaderComponent={() =>  <LikedLink /> }
        renderItem={({ item }) => <PlaylistItem playlist={item} />}
        estimatedItemSize={100}
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
    paddingVertical: 20,
  },
  playlistContainer: {
    display: 'flex',
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    padding: 10,
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  playlistImage: {
    width: 100,
    height: 100,
  },
});
