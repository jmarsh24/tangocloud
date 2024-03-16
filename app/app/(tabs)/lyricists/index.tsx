import React from 'react';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_LYRICISTS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, View, ActivityIndicator, StyleSheet } from 'react-native';
import LyricistItem from '@/components/LyricistItem';
import { SafeAreaView } from 'react-native-safe-area-context';

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
    <SafeAreaView style={styles.container}>
      <FlashList 
        data={lyricists}
        renderItem={({ item }) => <LyricistItem lyricist={item} />}
        keyExtractor={item => item.id}
        estimatedItemSize={100}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});

export default BrowseScreen;