import { FlashList } from '@shopify/flash-list';
import { SEARCH_SINGERS } from '@/graphql';
import { useQuery } from '@apollo/client';
import { View, Text, ActivityIndicator, StyleSheet } from 'react-native';
import SingerItem from '@/components/SingerItem';
import { useTheme } from '@react-navigation/native'
import { defaultStyles } from '@/styles'

const SingersScreen = () => {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(SEARCH_SINGERS, { variables: { query: '*' } });
  const singers = data?.searchSingers?.edges.map(edge => edge.node);

  console.log(singers);
  if (loading) {
    return (
    <View style={styles.container}>
      <ActivityIndicator />
    </View>
    )
  }

  if (error) {
    return <Text>Failed to fetch</Text>;
  }

  return (
    <View style={defaultStyles.container}>
      <Text style={[styles.title, { color: colors.text }]}>Singers</Text>
      <FlashList 
        data={singers}
        renderItem={({ item }) => <SingerItem singer={item} />}
        keyExtractor={item => item.id}
        estimatedItemSize={100}
        ListFooterComponentStyle={{ paddingBottom: 80 }}
      />
    </View>
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