import React, { useState, useEffect } from 'react';
import { StyleSheet, TouchableWithoutFeedback, View } from 'react-native';
import TrackPlayer, { usePlaybackState, RepeatMode } from 'react-native-track-player';
import FontAwesome6 from 'react-native-vector-icons/FontAwesome6';
import { useTheme } from '@react-navigation/native';
import { PlaybackError } from '@/components/PlaybackError';
import { PlayPauseButton } from '@/components/PlayPauseButton';

const performSkipToNext = () => TrackPlayer.skipToNext();
const performSkipToPrevious = () => TrackPlayer.skipToPrevious();

export const PlayerControls: React.FC = () => {
  const playback = usePlaybackState();
  const { colors } = useTheme();
  const [shuffleActive, setShuffleActive] = useState(false);
  const [repeatMode, setRepeatMode] = useState(RepeatMode.Off);

  useEffect(() => {
    const getRepeatMode = async () => {
      const mode = await TrackPlayer.getRepeatMode();
      setRepeatMode(mode);
    };

    getRepeatMode();
  }, []);

  const handleShuffle = async () => {
    let queue = await TrackPlayer.getQueue();
    await TrackPlayer.reset();
    queue.sort(() => Math.random() - 0.5);
    await TrackPlayer.add(queue);
    setShuffleActive(!shuffleActive);
    await TrackPlayer.play();
  };

  const toggleRepeatMode = async () => {
    let newMode;
    switch (repeatMode) {
      case RepeatMode.Off:
        newMode = RepeatMode.Track;
        break;
      case RepeatMode.Track:
        newMode = RepeatMode.Queue;
        break;
      case RepeatMode.Queue:
        newMode = RepeatMode.Off;
        break;
      default:
        newMode = RepeatMode.Off;
    }
    await TrackPlayer.setRepeatMode(newMode);
    setRepeatMode(newMode);
  };

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
    activeIcon: {
      color: "#ff7700",
    },
  });

  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <TouchableWithoutFeedback onPress={performSkipToPrevious}>
          <FontAwesome6 name={'backward'} size={30} style={styles.icon} />
        </TouchableWithoutFeedback>
        <PlayPauseButton />
        <TouchableWithoutFeedback onPress={performSkipToNext}>
          <FontAwesome6 name={'forward'} size={30} style={styles.icon} />
        </TouchableWithoutFeedback>
      </View>
      <View style={styles.row}>
        <TouchableWithoutFeedback onPress={handleShuffle}>
          <FontAwesome6 name={'shuffle'} size={30} style={shuffleActive ? styles.activeIcon : styles.icon} />
        </TouchableWithoutFeedback>
        <TouchableWithoutFeedback onPress={toggleRepeatMode}>
          <FontAwesome6 name={'repeat'} size={30} style={repeatMode !== RepeatMode.Off ? styles.activeIcon : styles.icon} />
        </TouchableWithoutFeedback>
      </View>
      <PlaybackError
        error={'error' in playback ? playback.error.message : undefined}
      />
    </View>
  );
};
