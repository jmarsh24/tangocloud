import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { Track } from '@/types';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import * as SecureStore from 'expo-secure-store';

type TrackListItemProps = {
  track: Track;
};

export default function TrackListItem({ track }: TrackListItemProps) {
  const { colors } = useTheme();

  const styles = getStyles(colors);

  const fetchAuthToken = async () => {
    return await SecureStore.getItemAsync('token');
  };
  
  const onTrackPress = async () => {
    const token = await fetchAuthToken(); // Fetch the token
    const trackForPlayer = {
      id: track.id,
      url: track.audios[0].url, // Your track URL
      title: track.title,
      artist: track.orchestra.name,
      artwork: track.albumArtUrl,
      // Assuming headers could be passed directly, which they can't in the current API.
      // This is illustrative only:
      headers: {
        Authorization: token ? `Bearer ${token}` : '',
      },
    };

    try {
      await TrackPlayer.reset(); // Clear any existing tracks
      // Since react-native-track-player does not support headers, you might need to ensure the URL is accessible without them,
      // or implement a mechanism to fetch the track to local storage here before adding it to the player.
      await TrackPlayer.add([trackForPlayer]);
      await TrackPlayer.play(); // Start playback
    } catch (error) {
      console.error('Error playing track:', error);
    }
  };

  return (
    <Pressable onPress={onTrackPress} style={styles.songCard}>
      <Image source={{ uri: track.albumArtUrl }} style={styles.songAlbumArt} />
      <View style={styles.songTextContainer}>
        <Text style={styles.songTitle}>{track.title}</Text>
        <Text style={styles.songDetails}>
          {track.orchestra.name} - {track.singers[0]?.name}
        </Text>
        <Text style={styles.songSubDetails}>
          {track.genre.name} - {track?.recordedDate}
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
