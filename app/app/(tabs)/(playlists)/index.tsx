import { Text, ActivityIndicator, StyleSheet, View } from 'react-native';
import PlaylistItem from '@/components/PlaylistItem';
import { SEARCH_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import LikedLink from '@/components/LikedLink';
import { useTheme } from '@react-navigation/native';
import { FlashList } from '@shopify/flash-list';

const PlaylistsScreen = () => {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "*", first: 20 } })
  const playlists = data?.searchPlaylists.edges.map((edge) => edge.node);
  
  if (loading) {
    return (
      <View style={styles.container}>
        <ActivityIndicator />
      </View>
    );
  }
  
  if (error) {
    return (
      <View style={styles.container}>
        <Text>Failed to fetch</Text>
      </View>
    );
  }
  
  return (
    <View style={styles.container}>
      <Text style={[styles.title,{color: colors.text}]}>
        Playlists
      </Text>
      <FlashList
        data={playlists}
        renderItem={({ item }) => <PlaylistItem playlist={item} />}
        ListHeaderComponent={<LikedLink />}
        estimatedItemSize={80}
        ListFooterComponentStyle={{ paddingBottom: 80 }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'flex-start',

  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});

export default PlaylistsScreen;