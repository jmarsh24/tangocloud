import React from 'react';
import { View, Text, StyleSheet, ActivityIndicator, FlatList } from 'react-native';
import TrackListItem from '@/components/TrackListItem';
import { gql, useQuery } from '@apollo/client';
import Colors from '@/constants/Colors';

// const query = gql`
//   query MyQuery($q: String!) {
//     searchElRecodoSongs(query: $q) {
//       id
//       title
//       orchestra
//       singer
//       composer
//       author
//       date
//       style
//     }
//   }
// `;

export default function LibraryScreen() {
  <View>
    <Text style={styles.header}>Library</Text>
  </View>
  // const { data, loading, error } = useQuery(query, {
  //   variables: { q: "*" },
  // });

  // if (loading) {
  //   return <ActivityIndicator size="large" color={Colors.light.tint} />;
  // }

  // if (error) {
  //   console.error(error);
  //   return <Text style={styles.errorText}>Error loading tracks</Text>;
  // }

  // const tracks = data?.searchElRecodoSongs || [];

  // return (
  //   <View style={styles.container}>
  //     <Text style={styles.header}>Library</Text>
  //     <FlatList
  //       data={tracks}
  //       renderItem={({ item }) => <TrackListItem track={item} />}
  //       keyExtractor={item => item.id.toString()}
  //       showsVerticalScrollIndicator={false}
  //     />
  //   </View>
  // );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 20,
    backgroundColor: Colors.light.background,
  },
  header: {
    fontSize: 24,
    fontWeight: 'bold',
    color: Colors.light.text,
    paddingHorizontal: 15,
    marginBottom: 10,
  },
  errorText: {
    color: 'red',
    fontSize: 16,
    textAlign: 'center',
    marginTop: 20,
  },
});