import React from 'react';
import { StyleSheet, TouchableWithoutFeedback, View } from 'react-native';
import TrackPlayer, { usePlaybackState } from 'react-native-track-player';
import FontAwesome6 from 'react-native-vector-icons/FontAwesome6';
import { useTheme } from '@react-navigation/native';
import { PlaybackError } from '@/components/PlaybackError';
import { PlayPauseButton } from '@/components/PlayPauseButton';

const performSkipToNext = () => TrackPlayer.skipToNext();
const performSkipToPrevious = () => TrackPlayer.skipToPrevious();

export const PlayerControls: React.FC = () => {
  const playback = usePlaybackState();
  const { colors } = useTheme();

  const styles = StyleSheet.create({
    container: {
      width: '100%',
    },
    row: {
      flexDirection: 'row',
      justifyContent: 'space-evenly',
      alignItems: 'center',
    },
    icon: {
      color: colors.text, 
    },
  });

  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <TouchableWithoutFeedback onPress={performSkipToPrevious}>
          <FontAwesome6 name={'backward'} size={30} style={styles.icon} />
        </TouchableWithoutFeedback>
        {/* Assuming PlayPauseButton also respects dark mode */}
        <PlayPauseButton />
        <TouchableWithoutFeedback onPress={performSkipToNext}>
          <FontAwesome6 name={'forward'} size={30} style={styles.icon} />
        </TouchableWithoutFeedback>
      </View>
      {/* Ensure PlaybackError component also supports dark mode if it has visual elements */}
      <PlaybackError
        error={'error' in playback ? playback.error.message : undefined}
      />
    </View>
  );
};