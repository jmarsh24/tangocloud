import React from 'react';
import { Text, View, StyleSheet, FlatList } from 'react-native'; // Corrected 'FlatList'
import { useTheme } from '@react-navigation/native';
import { GET_HOME_PLAYLISTS } from '@/graphql';
import { useQuery } from '@apollo/client';

export default function Page() {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(GET_HOME_PLAYLISTS, {
    variables: { first: 20 },
    fetchPolicy: 'cache-and-network',
  });

  // Check for loading and error states first
  if (loading) return <View style={styles.container}><Text>Loading playlists...</Text></View>;
  if (error) return <View style={styles.container}><Text>Error loading playlists.</Text></View>;

  // Safely access getHomePlaylists, ensuring it's not null
  const playlists = data?.getHomePlaylists?.edges.map(edge => edge.node) || [];

  return (
    <View style={styles.container}>
      <FlatList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View style={styles.playlistContainer}>
            <Text style={[styles.playlistTitle, { color: colors.text }]}>{item.title}</Text>
            <Text style={[styles.playlistDescription, { color: colors.text }]}>{item.description}</Text>
          </View>
        )}
      />
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
    </View>
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
    marginBottom: 20,
  },
  playlistContainer: {
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#cccccc',
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  playlistDescription: {
    fontSize: 14,
  },
});
