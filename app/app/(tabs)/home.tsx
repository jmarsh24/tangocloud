import React, { useState, useEffect } from 'react';
import { Text, View, StyleSheet, Image } from 'react-native';
import { useTheme} from '@react-navigation/native';
import { useQuery } from '@apollo/client';
import { Link } from 'expo-router';
import { FlashList } from '@shopify/flash-list';
import { SEARCH_PLAYLISTS } from '@/graphql';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function HomeScreen() {
  const { colors } = useTheme();
  const { data, loading, error } = useQuery(SEARCH_PLAYLISTS, 
    { variables: { query: "", first: 20 },
      fetchPolicy: 'network-only'
    },
  );
  console.log('data', data);
  // const { colors } = useTheme();
  // const [playlists, setPlaylists] = useState([]);
  // const [loading, setLoading] = useState(true);
  // const [error, setError] = useState(null);

  // useEffect(() => {
  //   const fetchData = async () => {
  //     setLoading(true);
  //     try {
  //       const response = await fetch("http://192.168.0.3:3000/api/graphql", {
  //         method: 'POST',
  //         headers: {
  //           'Content-Type': 'application/json',
  //           "authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTI0ZmEyM2EtYzRjOS00MjBiLWJhZmQtM2Q5NzdhMTRlOWIzIn0.l6OxkfOh5elKlfz3GWwN06Wv3-qe5mFTjL8q2Fe_NgY"
  //         },
  //         body: JSON.stringify({
  //           query: SEARCH_PLAYLISTS,
  //           variables: { query: "", first: 20},
  //         }),
  //       });
  //       const jsonResponse = await response.json();
  //       if (jsonResponse.errors) {
  //         setError(jsonResponse.errors[0].message);
  //       } else {
  //         setPlaylists(jsonResponse.data.searchPlaylists);
  //       }
  //     } catch (error) {
  //       setError(error.toString());
  //     } finally {
  //       setLoading(false);
  //     }
  //   };

  //   fetchData();
  // }, []);

  // console.log('data', playlists);

  // if (playlistsLoading) {
  //   return (
  //     <View style={styles.container}>
  //       <Text>Loading playlists...</Text>
  //     </View>
  //   );
  // }

  // if (playlistsError) {
  //   return (
  //     <View style={styles.container}>
  //       <Text>Error loading playlists.</Text>
  //     </View>
  //   );
  // }

  // const playlists = playlistsData?.searchPlaylists?.edges.map(edge => edge.node);

  // const renderPlaylistItem = ({ item }) => (
  //   <Link push href={{ pathname: "/playlists/[id]", params: { id: item.id } }}>
  //     <View style={styles.playlistContainer}>
  //       <Image source={{ uri: item.imageUrl }} style={styles.playlistImage} />
  //       <View style={styles.playlistInfo}>
  //         <Text style={[styles.playlistTitle, { color: colors.text }]}>
  //           {item.title}
  //         </Text>
  //       </View>
  //     </View>
  //   </Link>
  // );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={[styles.headerText, { color: colors.text }]}>
        The people who are crazy enough to think they can change the world are the ones who do.
      </Text>
      {/* <FlashList
        data={playlists}
        keyExtractor={(item) => item.id}
        renderItem={renderPlaylistItem}
        estimatedItemSize={100}
      /> */}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 10,
  },
  headerText: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    paddingHorizontal: 20,
    paddingVertical: 20,
  },
  playlistContainer: {
    display: 'flex',
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    padding: 10,
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  playlistImage: {
    width: 100,
    height: 100,
  },
});
