import { Text, FlatList, ActivityIndicator } from 'react-native';
import PlaylistItem from '@/components/PlaylistItem';
import { SEARCH_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';

export default function OrdersScreen() {
  const { data: playlists, loading, error } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "*", first: 20 } })

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }
  
  return (
    <FlatList
      data={playlists.searchPlaylists.edges.map((edge) => edge.node)}
      renderItem={({ item }) => <PlaylistItem playlist={item} />}
      contentContainerStyle={{ gap: 10, padding: 10 }}
    />
  );
}