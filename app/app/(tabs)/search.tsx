import {
  FlatList,
  TextInput,
  View,
  Text,
  StyleSheet,
  ActivityIndicator,
} from 'react-native';
import TrackListItem from '@/components/TrackListItem';
import { SafeAreaView } from 'react-native-safe-area-context';
import { AntDesign } from '@expo/vector-icons';
import { useState } from 'react';
import { gql, useQuery } from '@apollo/client';
import Colors from '@/constants/Colors';

const query = gql`
  query MyQuery($q: String!) {
    searchElRecodoSongs(query: $q) {
              id
              title
              orchestra
              singer
              composer
              author
              date
              style
            }
  }
`;

export default function SearchScreen() {
  const [search, setSearch] = useState('');

  const { data, loading, error } = useQuery(query, {
    variables: { q: search },
  });

  const tracks = data?.searchElRecodoSongs || [];

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

  return (
    <SafeAreaView>
      <View style={styles.header}>
        <View style={styles.searchContainer}>
          <AntDesign name="search1" size={20} style={styles.searchIcon} />
          <TextInput
            value={search}
            onChangeText={setSearch}
            placeholder="What do you want to listen to?"
            style={styles.input}
          />
          {search.length > 0 && (
            <AntDesign
              name="close"
              size={20}
              style={styles.clearIcon}
              onPress={() => setSearch('')}
            />
          )}
        </View>
        <Text onPress={() => setSearch('')} style={styles.cancelText}>
          Cancel
        </Text>
      </View>

      {loading && <ActivityIndicator />}
      {error && <Text>Failed to fetch tracks</Text>}

      <FlatList
        data={tracks}
        renderItem={({ item }) => <TrackListItem track={item} />}
        keyExtractor={item => item.id.toString()}
        ItemSeparatorComponent={ItemSeparator}
        showsVerticalScrollIndicator={false}
        style={styles.list}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  header: {
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingBottom: 10,
    paddingHorizontal: 10,
    gap: 12
  },
  searchContainer: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.light.tint,
    padding: 8,
    borderRadius: 5,
    position: 'relative'
  },
  input: {
    flex: 1,
    color: Colors.light.text,
    backgroundColor: Colors.light.tint,
    paddingVertical: 4,
    paddingLeft: 30,
    paddingRight: 4,
  },
  searchIcon: {
    position: 'absolute',
    color: Colors.light.searchIcon,
    left: 10,
  },
  clearIcon: {
    position: 'absolute',
    color: Colors.light.searchIcon,
    right: 10,
  },
  cancelText: {
    color: Colors.light.searchIcon,
    fontSize: 12,
  },
  list: {
    display: 'flex',
    flexDirection: 'column',
    gap: 5,
    paddingHorizontal: 10,
  },
  itemSeperator: {
    height: 10,
  },
});