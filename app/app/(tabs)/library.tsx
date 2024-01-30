import { ActivityIndicator, FlatList } from 'react-native';
import TrackListItem from '@/components/TrackListItem';
import { gql, useQuery } from '@apollo/client';

const query = gql`
  query MyQuery($q: String!) {
    searchElRecodoSongs(query: "*") {
              id
              title
              orchestra
              singer
              composer
              author
              date
              style
            }
  }
`;

export default function LibraryScreen() {
  const { data, loading, error } = useQuery(query);

  if (loading) {
    return <ActivityIndicator />;
  }
  if (error) {
    console.log(error);
  }
  console.log(data);
  const tracks = data?.searchElRecodoSongs || [];

  return (
    <FlatList
      data={tracks}
      renderItem={({ item }) => <TrackListItem track={item} />}
      showsVerticalScrollIndicator={false}
    />
  );
}