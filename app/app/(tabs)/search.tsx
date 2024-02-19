import React, { useState, useEffect, useCallback } from 'react';
import { TextInput, View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import { useQuery } from '@apollo/client';
import { useTheme } from '@react-navigation/native';
import { SEARCH_RECORDINGS } from '@/graphql';
import _ from 'lodash'; 

export default function SearchScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const ITEMS_PER_PAGE = 30;
  const [search, setSearch] = useState('');
  const [debouncedSearch, setDebouncedSearch] = useState("*");

  const { data, loading, fetchMore } = useQuery(SEARCH_RECORDINGS, {
    variables: { query: debouncedSearch, first: ITEMS_PER_PAGE },
    fetchPolicy: 'cache-and-network',
    skip: !debouncedSearch,
  });

  const debouncedSetSearch = useCallback(_.debounce(setDebouncedSearch, 500), []);

    useEffect(() => {
    if(search.trim()) {
      debouncedSetSearch(search);
    }
    return () => {
      debouncedSetSearch.cancel();
    };
  }, [search, debouncedSetSearch]);

  const loadMoreItems = useCallback(() => {
    if (data?.searchRecordings.pageInfo.hasNextPage) {
      fetchMore({
        variables: {
          after: data.searchRecordings.pageInfo.endCursor,
        },
        updateQuery: (prevResult, { fetchMoreResult }) => {
          const newEdges = fetchMoreResult.searchRecordings.edges;
          const pageInfo = fetchMoreResult.searchRecordings.pageInfo;

          return newEdges.length
            ? {
                searchRecordings: {
                  __typename: prevResult.searchRecordings.__typename,
                  edges: [...prevResult.searchRecordings.edges, ...newEdges],
                  pageInfo,
                },
              }
            : prevResult;
        },
      });
    }
  }, [data?.searchRecordings.pageInfo, fetchMore]);

  const tracks = data?.searchRecordings.edges.map(edge => edge.node) || [];

  const renderItem = useCallback(
    ({ item }) => <TrackListItem track={item} />,
    []
  );

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

  const ListFooter = () => {
    return (
      <View style={styles.footerStyle}>
      </View>
    );
  };

  return (
    <View style={{flex: 1}}>
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
        estimatedItemSize={30}
        keyExtractor={item => item.id}
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
    footerStyle: {
      height: 100,
    },
    itemSeperator: {
      height: 10,
    },
  });
}