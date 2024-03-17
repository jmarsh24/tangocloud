import { Text, View, FlatList, ActivityIndicator, StyleSheet } from 'react-native';
import PlaylistItem from '@/components/PlaylistItem';
import { SEARCH_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import LikedLink from '@/components/LikedLink';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@react-navigation/native';

export default function PlaylistsScreen() {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(SEARCH_PLAYLISTS, { variables: { query: "*", first: 20 } })
  const playlists = data?.searchPlaylists.edges.map((edge) => edge.node);
  
  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator />
      </SafeAreaView>
    );
  }
  
  if (error) {
    return (
      <SafeAreaView style={styles.container}>
        <Text>Failed to fetch</Text>
      </SafeAreaView>
    );
  }
  
  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.title,{color: colors.text}]}>
        Playlists
      </Text>
      <FlatList
        data={playlists}
        renderItem={({ item }) => <PlaylistItem playlist={item} />}
        ListHeaderComponent={<LikedLink />}
        contentContainerStyle={{ gap: 10, padding: 10 }}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'flex-start',
    paddingHorizontal: 20,
    paddingVertical: 10,

  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});