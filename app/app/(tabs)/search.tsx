import React, { useState, useCallback } from 'react';
import { TextInput, View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import { useQuery } from '@apollo/client';
import { useTheme } from '@react-navigation/native';
import { SEARCH_RECORDINGS } from '@/graphql';
import { debounce } from 'lodash';

export default function SearchScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors);

  const [search, setSearch] = useState('');
  const [currentPage, setCurrentPage] = useState(1);

  // Debounced setSearch function to optimize performance
  const debouncedSetSearch = useCallback(debounce(setSearch, 300), []);

  const { data, loading, error, fetchMore } = useQuery(SEARCH_RECORDINGS, {
    variables: { query: search || "*", page: currentPage, per_page: 50 },
    fetchPolicy: 'cache-and-network',
  });

  const tracks = data?.searchRecordings || [];

  const fetchPage = (page) => {
    if (!loading) {
      fetchMore({
        variables: {
          page: page,
        },
        updateQuery: (prev, { fetchMoreResult }) => {
          if (!fetchMoreResult) return prev;
          return Object.assign({}, prev, {
            searchRecordings: [...prev.searchRecordings, ...fetchMoreResult.searchRecordings]
          });
        },
      });
      setCurrentPage(page);
    }
  };

  const handleEndReached = () => {
    // Here you need to implement logic to determine if there are more pages to fetch
    // For simplicity, we'll just increment the currentPage. You might need to adjust this based on your API's response structure.
    const nextPage = currentPage + 1;
    fetchPage(nextPage);
  };

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

  const renderItem = useCallback(
    ({ item }) => <TrackListItem track={item} />,
    []
  );

  return (
    <View style={{flex: 1}}>
      <View style={styles.header}>
        <View style={styles.searchContainer}>
          <AntDesign name="search1" size={20} style={styles.searchIcon} />
          <TextInput
            value={search}
            onChangeText={(text) => debouncedSetSearch(text)}
            placeholder="What do you want to listen to?"
            autoCorrect={false}
            autoComplete='off'
            autoCapitalize='none'
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

      <FlashList
        data={tracks}
        renderItem={renderItem}
        ItemSeparatorComponent={ItemSeparator}
        ListFooterComponent={ () => loading && <ActivityIndicator />}
        contentContainerStyle={{ gap: 10 }}
        onEndReached={handleEndReached}
        onEndReachedThreshold={0.5}
        showsVerticalScrollIndicator={false}
        estimatedItemSize={50}
        debug
      />
    </View>
  );
}

function getStyles(colors) {
  return StyleSheet.create({
    header: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingBottom: 10,
      paddingHorizontal: 10,
      gap: 12,
      padding: 10,
      backgroundColor: colors.background,
    },
    searchContainer: {
      flex: 1,
      flexDirection: 'row',
      alignItems: 'center',
      backgroundColor: colors.card,
      padding: 8,
      borderRadius: 5,
      position: 'relative'
    },
    input: {
      flex: 1,
      color: colors.text,
      backgroundColor: colors.card,
      paddingVertical: 4,
      paddingLeft: 30,
      paddingRight: 4,
    },
    searchIcon: {
      position: 'absolute',
      color: colors.text,
      left: 10,
      zIndex: 1,
    },
    clearIcon: {
      position: 'absolute',
      color: colors.text,
      right: 10,
    },
    cancelText: {
      color: colors.text,
      fontSize: 12,
    },
    // list: {
    //   flexDirection: 'column',
    //   gap: 5,
    //   paddingHorizontal: 10,
    // },
    itemSeperator: {
      height: 10,
    },
  });
}