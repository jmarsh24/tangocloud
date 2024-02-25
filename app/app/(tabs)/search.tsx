import React, { useState, useEffect, useCallback } from 'react';
import { TextInput, View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import { useQuery } from '@apollo/client';
import { useTheme } from '@react-navigation/native';
import { RECORDINGS } from '@/graphql';
import _ from 'lodash'; 
import { SafeAreaView } from 'react-native-safe-area-context';

export default function SearchScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const ITEMS_PER_PAGE = 30;
  const [search, setSearch] = useState('');

  const { data, loading, fetchMore } = useQuery(RECORDINGS, {
    variables: { query: search, first: ITEMS_PER_PAGE },
    fetchPolicy: 'cache-and-network',
  });

  // Debounce search input to delay execution while typing
  const debouncedSearch = useCallback(_.debounce((query) => {
    fetchMore({
      variables: { query: query || "", first: ITEMS_PER_PAGE },
      updateQuery: (prev, { fetchMoreResult }) => {
        if (!fetchMoreResult) return prev;
        return fetchMoreResult;
      },
    });
  }, 500), []);

  useEffect(() => {
    debouncedSearch(search);
  }, [search, debouncedSearch]);

  const loadMoreItems = useCallback(() => {
    if (data?.recordings.pageInfo.hasNextPage) {
      fetchMore({
        variables: {
          after: data.recordings.pageInfo.endCursor,
        },
      });
    }
  }, [data?.recordings.pageInfo, fetchMore]);

  const tracks = data?.recordings.edges.map(edge => edge.node) || [];

  const renderItem = useCallback(
    ({ item }) => <TrackListItem track={item} />,
    []
  );

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

  const ListFooter = () => loading ? <ActivityIndicator size="medium" /> : <View style={styles.footerStyle}></View>;

  return (
    <SafeAreaView style={{ flex: 1 }}>
      <View style={styles.header}>
        <View style={styles.searchContainer}>
          <AntDesign name="search1" size={20} style={styles.searchIcon} />
          <TextInput
            value={search}
            onChangeText={setSearch}
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
        ListFooterComponent={ListFooter}
        onEndReached={loadMoreItems}
        onEndReachedThreshold={0.5}
        showsVerticalScrollIndicator={false}
        estimatedItemSize={75} // Adjusted for potentially varying item sizes
        keyExtractor={item => item.id}
      />
    </SafeAreaView>
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
    footerStyle: {
      height: 100,
    },
    itemSeperator: {
      height: 10,
    },
  });
}