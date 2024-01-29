import { ActivityIndicator, FlatList, Text, View, StyleSheet } from 'react-native';
import TrackListItem from '../../components/TrackListItem';
import { gql, useQuery } from '@apollo/client';

const query = gql`
  query MyQuery($genres: String!) {
    recommendations(seed_genres: $genres) {
      tracks {
        id
        name
        preview_url
        artists {
          id
          name
        }
        album {
          id
          name
          images {
            url
            width
            height
          }
        }
      }
    }
  }
`;

export default function HomeScreen() {
  const { data, loading, error } = useQuery(query, {
    variables: { genres: 'drum-and-bass,house' },
  });

  if (loading) {
    return <ActivityIndicator />;
  }

  if (error) {
    return (
      <View style={styles.centeredView}>
        <Text style={styles.errorText}>
          The people who are crazy enough to think they can change the world are the ones who do.
        </Text>
      </View>
    );
  }

  const tracks = data?.recommendations?.tracks || [];

  return (
    <FlatList
      data={tracks}
      renderItem={({ item }) => <TrackListItem track={item} />}
      showsVerticalScrollIndicator={false}
    />
  );
}

const styles = StyleSheet.create({
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorText: {
    color: 'white',
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingHorizontal: 20, // to ensure the text is not cut off on small screens
  }
});