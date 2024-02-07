import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { Track } from '@/types';
import { usePlayerContext } from '@/providers/PlayerProvider';
import { useTheme } from '@react-navigation/native';

type TrackListItemProps = {
  track: Track;
};

export default function TrackListItem({ track }: TrackListItemProps) {
  const { setTrack } = usePlayerContext();
  const { colors } = useTheme();

  const styles = getStyles(colors);

  return (
    <Pressable onPress={() => setTrack(track)} style={styles.songCard}>
      <Image source={{ uri: track.albumArtUrl }} style={styles.songAlbumArt} />
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

function getStyles(colors) {
  return StyleSheet.create({
    songCard: {
      flex: 1,
      backgroundColor: colors.card, 
      flexDirection: "row",
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
      color: colors.text, 
      marginLeft: 10,
    },
    songDetails: {
      fontSize: 14,
      color: colors.text, 
      marginLeft: 10,
    },
    songSubDetails: {
      fontSize: 12,
      color: colors.text, 
      marginLeft: 10,
    },
    songTextContainer: {
      flexDirection: "column",
    },
  });
}
