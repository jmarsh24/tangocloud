import React from 'react';
import { Stack } from 'expo-router';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_SINGERS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, View, ActivityIndicator, StyleSheet } from 'react-native';
import SingerItem from '@/components/SingerItem';

const SingersScreen = () => {
  const { data, loading, error } = useQuery(SEARCH_SINGERS, { variables: { query: '*' } });
  const singers = data?.searchSingers?.edges.map(edge => edge.node);
  console.log(singers);
  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  return (
    <View style={styles.container}>
      <FlashList 
        data={singers}
        renderItem={({ item }) => <SingerItem singer={item} />}
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

export default SingersScreen;