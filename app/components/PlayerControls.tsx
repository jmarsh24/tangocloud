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

  return (
    <View style={styles.container}>
      <View style={styles.row}>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={handleShuffle}>
            <FontAwesome6 name={'shuffle'} size={30} style={shuffleActive ? styles.activeIcon : {color: colors.text}} />
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={performSkipToPrevious}>
            <FontAwesome6 name={'backward'} size={30} style={{color: colors.text}} />
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.control}>
          <PlayPauseButton />
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={performSkipToNext}>
            <FontAwesome6 name={'forward'} size={30} style={{color: colors.text}} />
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={toggleRepeatMode}>
            <FontAwesome6 name={'repeat'} size={30} style={repeatMode !== RepeatMode.Off ? {color: colors.text} : styles.activeIcon} />
          </TouchableWithoutFeedback>
        </View>
      </View>
      <PlaybackError
        error={'error' in playback ? playback.error.message : undefined}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    alignItems: 'center',
    width: '100%',
  },
  row: {
    flexDirection: 'row',
    width: '100%',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  control: {
    flex: 1,
    alignItems: 'center',
  },
  activeIcon: {
    color: "#ff7700",
  },
});