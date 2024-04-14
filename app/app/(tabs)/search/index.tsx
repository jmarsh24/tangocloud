  import React, { useState, useEffect, useCallback } from "react";
  import {
    TextInput,
    View,
    Text,
    StyleSheet,
    ActivityIndicator,
  } from "react-native";
  import { FlashList } from "@shopify/flash-list";
  import TrackListItem from "@/components/TrackListItem";
  import { AntDesign } from "@expo/vector-icons";
  import { useQuery } from "@apollo/client";
  import { useTheme } from "@react-navigation/native";
  import { SEARCH_RECORDINGS } from "@/graphql";
  import { SafeAreaView } from "react-native-safe-area-context";
  import { Link } from "expo-router";

  export default function SearchScreen() {
    const { colors } = useTheme();
    const ITEMS_PER_PAGE = 200;
    const [search, setSearch] = useState("");
    const [loadingMore, setLoadingMore] = useState(false);

    const { data, loading, fetchMore, error } = useQuery(SEARCH_RECORDINGS, {
      variables: { query: search, first: ITEMS_PER_PAGE },
      fetchPolicy: "cache-and-network",
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

    const tracks =
      data?.searchRecordings.edges.map((edge) => ({
        id: edge.node.id,
        title: edge.node.title,
        artist: edge.node.orchestra.name,
        duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
        artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || "",
        url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || "",
        genre: edge.node.genre.name,
        year: edge.node.year,
        singer: edge.node.singers[0]?.name,
      })) || [];

    return (
      <SafeAreaView edges={['right', 'top', 'left']} style={{ flex: 1 }}>
        <View style={[styles.header, { backgroundColor: colors.background }]}>
          <View style={[styles.searchContainer, { backgroundColor: colors.card }]}>
            <AntDesign name="search1" size={20} style={[styles.searchIcon, { color: colors.text}]} />
            <TextInput
              value={search}
              onChangeText={setSearch}
              placeholder="What do you want to listen to?"
              autoCorrect={false}
              autoComplete="off"
              autoCapitalize="none"
              style={[styles.input, { color: colors.text, backgroundColor: colors.card}]}
            />
            {search.length > 0 && (
              <AntDesign
                name="close"
                size={20}
                style={[styles.clearIcon, { color: colors.text }]}
                onPress={() => setSearch("")}
              />
            )}
          </View>
        </View>
        {search.length === 0 && (
          <View style={styles.linksContainer}>
            <Link style={[styles.linkButton, { backgroundColor: colors.card }]} push href="/orchestras">
              <Text style={[styles.buttonText, { color: colors.text }]}>Orchestras</Text>
            </Link>
            <Link style={[styles.linkButton, { backgroundColor: colors.card }]} push href="/singers">
              <Text style={[styles.buttonText, { color: colors.text }]}>Singers</Text>
            </Link>
            <Link style={[styles.linkButton, { backgroundColor: colors.card }]} push href="/composers">
              <Text style={[styles.buttonText, { color: colors.text }]}>Composers</Text>
            </Link>
            <Link style={[styles.linkButton, { backgroundColor: colors.card }]} push href="/lyricists">
              <Text style={[styles.buttonText, { color: colors.text }]}>Lyricists</Text>
            </Link>
          </View>
        )}
        <FlashList
          data={tracks}
          renderItem={({ item }) => <TrackListItem track={item} tracks={tracks} />}
          ItemSeparatorComponent={() => <View style={styles.itemSeparator} />}
          onEndReached={loadMoreItems}
          onEndReachedThreshold={0.5}
          showsVerticalScrollIndicator={false}
          estimatedItemSize={75}
          ListFooterComponentStyle={{ paddingBottom: 80 }}
        />
      </SafeAreaView>
    );
  }

  const styles = StyleSheet.create({
    header: {
      flexDirection: "row",
      justifyContent: "space-between",
      alignItems: "center",
      
      gap: 10,
    },
    linksContainer: {
      flexDirection: 'row',
      flexWrap: 'wrap',
      justifyContent: 'space-between',
      gap: 10,
    },
    linkButton: {
      width: '48%',
      padding: 30,
    },
    button: {
      padding: 10,
      borderWidth: 1,
      borderRadius: 5,
      alignItems: 'center',
    },
    searchContainer: {
      flex: 1,
      flexDirection: "row",
      alignItems: "center",
      padding: 8,
      borderRadius: 5,
      position: "relative",
    },
    input: {
      flex: 1,
      paddingVertical: 4,
      paddingLeft: 30,
      paddingRight: 4,
    },
    searchIcon: {
      position: "absolute",
      left: 10,
      zIndex: 1,
    },
    clearIcon: {
      position: "absolute",
      right: 10,
    },
    footerStyle: {
      height: 100,
    },
    itemSeparator: {
      height: 10,
    },
    buttonText: {
      fontSize: 16,
      fontWeight: "bold",
      textAlign: "center",
    },
  });