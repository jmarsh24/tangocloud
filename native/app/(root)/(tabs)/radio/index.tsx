import { defaultStyles } from '@/styles'
import { View, Text, StyleSheet } from 'react-native';
import { FlashList } from '@shopify/flash-list';
import { useQuery } from '@apollo/client';
import { ORCHESTRAS } from '@/graphql';
import { OrchestraEdge } from '@/graphql/__generated__/graphql';
import OrchestraItem from '@/components/OrchestraItem';

const Radio = () => {
  const { data, loading, error } = useQuery(ORCHESTRAS);

  if (loading) {
    return (
      <View style={styles.container}>
        <Text style={styles.text}>
          Loading...
        </Text>
      </View>
    );
  }

  if (error) {
    return (
      <View style={styles.container}>
        <Text style={styles.text}>
          Error: {error.message}
        </Text>
      </View>
    );
  }

  const orchestraEdges = data?.orchestras?.edges ?? [];

  return (
    <View style={[defaultStyles.container, styles.container]}>
      <View style={styles.orchestraList}>
        <FlashList
          data={orchestraEdges}
          keyExtractor={(item: OrchestraEdge) => item.node.id}
          renderItem={({ item }: { item: OrchestraEdge }) => (
            <OrchestraItem
              name={item.node.name}
              imageUrl={item.node?.image?.blob.url}
            />
          )}
          estimatedItemSize={50}
          horizontal={true}
          showsHorizontalScrollIndicator={false}
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontSize: 20,
    color: 'white',
  },
  orchestraList: {
    flex: 1,
    width: '100%',
  },
});

export default Radio;
