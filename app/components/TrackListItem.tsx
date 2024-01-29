import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { Track } from '../types';
import { usePlayerContext } from '../providers/PlayerProvider';

type TrackListItemProps = {
  track: Track;
};

export default function TrackListItem({ track }: TrackListItemProps) {
  const { setTrack } = usePlayerContext();

  return (
    <Pressable onPress={() => setTrack(track)} style={styles.container}>
      {/* <Image
        source={{ uri: track.album.images[0]?.url }}
        style={styles.image}
      /> */}
      <View style={styles.songCard}>
        <Text style={styles.songTitle}>{track.title}</Text>
        <Text style={styles.songDetails}>
          {track.orchestra} - {track.singer}
        </Text>
        <Text style={styles.songSubDetails}>
          {track.style} - {track.date}
        </Text>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 5,
    flexDirection: 'row',
    alignItems: 'center',
    width: '100%',
  },
  image: {
    width: 50,
    aspectRatio: 1,
    borderRadius: 5,
    marginRight: 10,
  }, 
  songCard: {
    flex: 1,
    backgroundColor: "black",
    display: "flex",
    flexDirection: "column",
    gap: 5,
    paddingTop: 20,
    paddingBottom: 20,
    paddingLeft: 10,
    paddingRight: 10,
    borderRadius: 8,
  },
  songTitle: {
    fontWeight: "bold",
    fontSize: 16,
    color: "white",
    marginLeft: 10,
  },
  songDetails: {
    fontSize: 14,
    color: "#999",
    marginLeft: 10,
  },
  songSubDetails: {
    fontSize: 12,
    color: "#888",
    marginLeft: 10,
  }
});