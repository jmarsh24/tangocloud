import React from 'react';
import { Stack } from 'expo-router';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_LYRICISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, View, ActivityIndicator, StyleSheet } from 'react-native';
import LyricistItem from '@/components/LyricistItem';

const BrowseScreen = () => {
  const { data, loading, error } = useQuery(SEARCH_LYRICISTS, { variables: { query: '*' } });
  const lyricists = data?.searchLyricists?.edges.map(edge => edge.node);

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  return (
    <View style={styles.container}>
      <FlashList 
        data={lyricists}
        renderItem={({ item }) => <LyricistItem lyricist={item} />}
        keyExtractor={item => item.id}
        estimatedItemSize={100}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default BrowseScreen;