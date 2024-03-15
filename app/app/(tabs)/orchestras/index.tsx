import React from 'react';
import { Stack } from 'expo-router';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_ORCHESTRAS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, View, ActivityIndicator, StyleSheet } from 'react-native';
import OrchestraItem from '@/components/OrchestraItem';

const OrchestrasScreen = () => {
  const { data, loading, error } = useQuery(SEARCH_ORCHESTRAS, { variables: { query: '*' } });
  const orchestras = data?.searchOrchestras?.edges.map(edge => edge.node);

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  return (
    <View style={styles.container}>
      <FlashList 
        data={orchestras}
        renderItem={({ item }) => <OrchestraItem orchestra={item} />}
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

export default OrchestrasScreen;