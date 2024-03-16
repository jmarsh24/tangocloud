import { Text, FlatList, ActivityIndicator } from 'react-native';
import PlaylistItem from '@/components/PlaylistItem';
import { SEARCH_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import LikedLink from '@/components/LikedLink';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function PlaylistsScreen() {
  const { data, loading, error } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "*", first: 20 } })
  const playlists = data?.searchPlaylists.edges.map((edge) => edge.node);
  
  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }
  
  return (
    <SafeAreaView>
      <FlatList
        data={playlists}
        renderItem={({ item }) => <PlaylistItem playlist={item} />}
        ListHeaderComponent={<LikedLink />}
        contentContainerStyle={{ gap: 10, padding: 10 }}
      />
    </SafeAreaView>
  );
}
