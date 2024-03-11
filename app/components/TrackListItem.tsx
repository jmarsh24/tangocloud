import { Text, View, StyleSheet, Image, Pressable } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import { useMutation } from '@apollo/client';
import { CREATE_PLAYBACK } from "@/graphql";

export default function TrackListItem({ track }) {
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const [createPlayback, { loading, error }] = useMutation(CREATE_PLAYBACK);

  if (!track) {
    return null;
  }

  const onTrackPress = async () => {
    const trackForPlayer = {
      id: track.id,
      url: track.url,
      title: track.title,
      artist: track.artist,
      artwork: track.artwork,
      duration: track.duration,
    };

    try {
      await createPlayback({
        variables: {
          recordingId: track.id,
        },
      });

      await TrackPlayer.reset();
      await TrackPlayer.add([trackForPlayer]);
      await TrackPlayer.play();
    } catch (error) {
      console.error('Error creating playback or playing track:', error);
    }
  };

  return (
    <Pressable onPress={onTrackPress} style={styles.songCard}>
      <Image source={{ uri: track.artwork }} style={styles.songAlbumArt} />
      <View style={styles.songTextContainer}>
        <Text style={styles.songTitle}>{track.title}</Text>
        <Text style={styles.songDetails}>{track.artist}</Text>
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
      paddingVertical: 10,
      paddingHorizontal: 10,
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
    songTextContainer: {
      flexDirection: "column",
    },
    loadingText: {
      fontSize: 14,
      color: colors.text,
      marginLeft: 10,
    },
    errorText: {
      fontSize: 14,
      color: 'red',
      marginLeft: 10,
    },
  });
}