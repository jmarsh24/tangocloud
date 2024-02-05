import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { Track } from '@/types';
import { usePlayerContext } from '@/providers/PlayerProvider';
import Colors from '@/constants/Colors';

type TrackListItemProps = {
  track: Track;
};

export default function TrackListItem({ track }: TrackListItemProps) {
  const { setTrack } = usePlayerContext();

  return (
    <Pressable onPress={() => setTrack(track)} style={styles.songCard}>
      <Image source={require('@/assets/images/album_art.jpg')} style={styles.songAlbumArt} />
      <View style={styles.songTextContainer}>
        <Text style={styles.songTitle}>{track.title}</Text>
        <Text style={styles.songDetails}>
          {track.orchestra.name} - {track.singers[0]?.name}
        </Text>
        <Text style={styles.songSubDetails}>
          {track.genre.name}
        </Text>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  songCard: {
    flex: 1,
    backgroundColor: Colors.light.tint,
    display: "flex",
    flexDirection: "row",
    gap: 5,
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 10,
    paddingRight: 10,
    borderRadius: 8,
  },
  songAlbumArt: {
    width: 56,
    height: 56,
    aspectRatio: 1,
    borderRadius: 5,
  }, 
  songTitle: {
    fontWeight: "bold",
    fontSize: 16,
    color: Colors.light.text,
    marginLeft: 10,
  },
  songDetails: {
    fontSize: 14,
    color: Colors.light.text,
    marginLeft: 10,
  },
  songSubDetails: {
    fontSize: 12,
    color: Colors.light.text,
    marginLeft: 10,
  },
  songTextContainer: {
    display: "flex",
    flexDirection: "column",
  },
});