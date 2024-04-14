import React from 'react';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_SINGERS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { Text, ActivityIndicator, StyleSheet } from 'react-native';
import SingerItem from '@/components/SingerItem';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useTheme } from '@react-navigation/native'

const SingersScreen = () => {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(SEARCH_SINGERS, { variables: { query: '*' } });
  const singers = data?.searchSingers?.edges.map(edge => edge.node);

  console.log(singers);
  if (loading) {
    return (
    <SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
      <ActivityIndicator />
    </SafeAreaView>
    )
  }

  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  return (
    <SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
      <Text style={[styles.title, { color: colors.text }]}>Singers</Text>
      <FlashList 
        data={singers}
        renderItem={({ item }) => <SingerItem singer={item} />}
        keyExtractor={item => item.id}
        estimatedItemSize={100}
        ListFooterComponentStyle={{ paddingBottom: 80 }}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingHorizontal: 20,
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'flex-start',
    
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    margin: 10,
  },
});

export default SingersScreen;