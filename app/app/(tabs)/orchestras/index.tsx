import React from 'react';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_ORCHESTRAS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { View, ActivityIndicator, StyleSheet } from 'react-native';
import OrchestraItem from '@/components/OrchestraItem';
import { SafeAreaView } from 'react-native-safe-area-context';

const OrchestrasScreen = () => {
  const { data, loading, error } = useQuery(SEARCH_ORCHESTRAS, { variables: { query: '*' } });
  const orchestras = data?.searchOrchestras?.edges.map(edge => edge.node);

  if (loading) {
    return (
    <View style={styles.container}>
      <ActivityIndicator />;
    </View>
    );
  }
  if (error) {
    return (
      <View style={styles.container}>
        <ActivityIndicator />;
      </View>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlashList 
        data={orchestras}
        renderItem={({ item }) => <OrchestraItem orchestra={item} />}
        estimatedItemSize={100}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default OrchestrasScreen;