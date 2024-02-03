import {
  FlatList,
  TextInput,
  View,
  Text,
  StyleSheet,
  ActivityIndicator,
} from 'react-native';
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import React, { useState, useCallback } from 'react';
import { gql, useQuery } from '@apollo/client';
import Colors from '@/constants/Colors';

const query = gql`
  query MyQuery($query: String!) {
       searchRecordings(query: $query) {
              title
							# audios {
              #   id
              #   length
              #   fileUrl
              # }
              orchestra {
                name
              }
      				# singers {
              #   name
              # }
              # genre {
              #   name
              # }
              recordedDate
            }
  }
`;

export default function SearchScreen() {
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [isFetchingMore, setIsFetchingMore] = useState(false);

  const { data, loading, error, fetchMore } = useQuery(query, {
    variables: { query: search, page: 1, per_page: 10 },
    fetchPolicy: 'cache-and-network',
  });

  const tracks = data?.searchRecordings || [];

  const loadMoreTracks = useCallback(() => {
    if (isFetchingMore) return;

    setIsFetchingMore(true);
    setPage(prevPage => prevPage + 1);

    fetchMore({
      variables: { query: search, page: page + 1, per_page: 10 },
      updateQuery: (prev, { fetchMoreResult }) => {
        setIsFetchingMore(false);

        if (!fetchMoreResult) return prev;
        return Object.assign({}, prev, {
          searchRecordings: [
            ...prev.searchRecordings,
            ...fetchMoreResult.searchRecordings,
          ],
        });
      },
    });
  }, [isFetchingMore, search, page, fetchMore]);

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

  return (
    <View>
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
        keyExtractor={item => item.id + Math.random().toString()} // Example of creating a more unique key
        ItemSeparatorComponent={ItemSeparator}
        showsVerticalScrollIndicator={false}
        style={styles.list}
        onEndReached={loadMoreTracks}
        onEndReachedThreshold={0.5} // Trigger the load more function when halfway through the last item
      />
    </View>
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
    gap: 12,
    padding: 10,
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
    zIndex: 1,
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