import React from 'react';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_COMPOSERS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, ActivityIndicator, StyleSheet } from 'react-native';
import ComposerItem from '@/components/ComposerItem';
import { SafeAreaView } from 'react-native-safe-area-context';

const ComposerScreen = () => {
  const { data, loading, error } = useQuery(SEARCH_COMPOSERS, { variables: { query: '*' } });
  const composers = data?.searchComposers?.edges.map(edge => edge.node);

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  if (!composers) {
    return <Text>No composers found</Text>;
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlashList 
        data={composers}
        renderItem={({ item }) => <ComposerItem composer={item} />}
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

export default ComposerScreen;