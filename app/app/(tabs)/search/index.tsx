import React, { useState, useEffect, useCallback } from 'react';
import { TextInput, View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import { useQuery } from '@apollo/client';
import { useTheme } from '@react-navigation/native';
import { SEARCH_RECORDINGS } from '@/graphql';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Link } from 'expo-router';

export default function SearchScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const ITEMS_PER_PAGE = 200;
  const [search, setSearch] = useState('');
  const [loadingMore, setLoadingMore] = useState(false);

  const { data, loading, fetchMore, error } = useQuery(SEARCH_RECORDINGS, {
    variables: { query: search, first: ITEMS_PER_PAGE },
    fetchPolicy: 'cache-and-network',
  });

  useEffect(() => {
    if (error) {
      console.log("Apollo Query Error:", error);
    }
  }, [error]);

  const loadMoreItems = useCallback(async () => {
    if (data?.searchRecordings.pageInfo.hasNextPage && !loadingMore) {
      setLoadingMore(true);
      await fetchMore({
        variables: {
          after: data.searchRecordings.pageInfo.endCursor,
          query: search,
          first: ITEMS_PER_PAGE,
        },
        updateQuery: (prev, { fetchMoreResult }) => {
          if (!fetchMoreResult) return prev;

          const newEdges = fetchMoreResult.searchRecordings.edges;
          const pageInfo = fetchMoreResult.searchRecordings.pageInfo;

          return {
            searchRecordings: {
              __typename: prev.searchRecordings.__typename,
              edges: [...prev.searchRecordings.edges, ...newEdges],
              pageInfo,
            },
          };
        },
      });
      setLoadingMore(false);
    }
  }, [data?.searchRecordings.pageInfo, fetchMore, loadingMore, search]);

  const tracks = data?.searchRecordings.edges.map(edge => ({
    id: edge.node.id,
    title: edge.node.title,
    artist: edge.node.orchestra.name,
    duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
    artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || "",
    url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || "",
  })) || [];

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
      {search.length === 0 && (
        <>
          <Link style={styles.link} push href="/orchestras">
            <View style={[styles.button, { backgroundColor: '#FFDDDD' }]}>
              <Text style={[styles.buttonText, { color: colors.text }]}>Orchestras</Text>
            </View>
          </Link>
          <Link style={styles.link} push href="/singers">
            <View style={[styles.button, { backgroundColor: '#DDFFDD' }]}>
              <Text style={[styles.buttonText, { color: colors.text }]}>Singers</Text>
            </View>
          </Link>
          <Link style={styles.link} push href="/composers">
            <View style={[styles.button, { backgroundColor: '#DDDFFF' }]}>
              <Text style={[styles.buttonText, { color: colors.text }]}>Composers</Text>
            </View>
          </Link>
          <Link style={styles.link} push href="/lyricists">
            <View style={[styles.button, { backgroundColor: '#FFDFFF' }]}>
              <Text style={[styles.buttonText, { color: colors.text }]}>Lyricists</Text>
            </View>
          </Link>
        </>
      )}
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
    itemSeparator: {
      height: 10,
    },
    link: {
      width: "100%",
      borderColor: "red"
    },
    button: {
      width: "100%",
      padding: 10,
      borderWidth: 1,
      borderRadius: 5,
      borderColor: "red"
    },
    buttonText: {
      fontSize: 16,
      fontWeight: 'bold',
      textAlign: 'center',
    },
  });
}