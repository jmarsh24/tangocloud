import { TextInput, View, Text, StyleSheet, ActivityIndicator} from 'react-native';
import { FlashList } from "@shopify/flash-list";
import TrackListItem from '@/components/TrackListItem';
import { AntDesign } from '@expo/vector-icons';
import React, { useState } from 'react';
import { useQuery } from '@apollo/client';
import { useTheme } from '@react-navigation/native';
import { SEARCH_RECORDINGS } from '@/graphql';

export default function SearchScreen() {
  const { colors } = useTheme();
  const styles = getStyles(colors);

  const [search, setSearch] = useState('');

  const { data, loading, error } = useQuery(SEARCH_RECORDINGS, {
    variables: { query: search || "*", page: 1, per_page: 50 },
    fetchPolicy: 'cache-and-network',
  });

  const tracks = data?.searchRecordings || [];

  const ItemSeparator = () => <View style={styles.itemSeperator} />;

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

      {loading && <ActivityIndicator />}
      {error && <Text>Failed to fetch tracks</Text>}

      <FlashList
        data={tracks}
        renderItem={({ item }) => <TrackListItem track={item} />}
        ItemSeparatorComponent={ItemSeparator}
        showsVerticalScrollIndicator={false}
        estimatedItemSize={50}
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