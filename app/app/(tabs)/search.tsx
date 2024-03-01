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
  const [loadingMore, setLoadingMore] = useState(false);

  const { data, loading, fetchMore, refetch, error } = useQuery(RECORDINGS, {
    variables: { query: search, first: ITEMS_PER_PAGE },
    fetchPolicy: 'cache-and-network',
  });

  useEffect(() => {
    refetch({ query: search, first: ITEMS_PER_PAGE });
  }, [search, refetch]);

  const loadMoreItems = useCallback(async () => {
    if (data?.recordings.pageInfo.hasNextPage && !loadingMore) {
      setLoadingMore(true);
      await fetchMore({
        variables: {
          after: data.recordings.pageInfo.endCursor,
          query: search,
          first: ITEMS_PER_PAGE,
        },
      });
      setLoadingMore(false);
    }
  }, [data?.recordings.pageInfo, fetchMore, loadingMore, search]);
  const tracks = data?.recordings.edges.map(edge => edge.node) || [];

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
            <AntDesign name="close" size={20} style={styles.clearIcon} onPress={() => setSearch('')} />
          )}
        </View>
      </View>

      <FlashList
        data={tracks}
        renderItem={({ item }) => <TrackListItem track={item} />}
        ItemSeparatorComponent={() => <View style={styles.itemSeparator} />}
        ListFooterComponent={() => loading || loadingMore ? <ActivityIndicator size="large" /> : null}
        onEndReached={loadMoreItems}
        onEndReachedThreshold={0.5}
        showsVerticalScrollIndicator={false}
        estimatedItemSize={75}
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