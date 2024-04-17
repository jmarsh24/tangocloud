import React, { useState, useEffect } from 'react';
import { StyleSheet, TouchableWithoutFeedback, View } from 'react-native';
import TrackPlayer, { usePlaybackState, RepeatMode } from 'react-native-track-player';
import { MaterialIcons } from '@expo/vector-icons';
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
          {/* <TouchableWithoutFeedback onPress={handleShuffle}>
            <MaterialIcons name={shuffleActive ? 'shuffle' : 'shuffle-on'} size={30} style={{ color: shuffleActive ? "#ff7700" : colors.text }} />
          </TouchableWithoutFeedback> */}
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={performSkipToPrevious}>
            <MaterialIcons name={'skip-previous'} size={30} style={{ color: colors.text }} />
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.control}>
          <PlayPauseButton />
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={performSkipToNext}>
            <MaterialIcons name={'skip-next'} size={30} style={{ color: colors.text }} />
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.control}>
          <TouchableWithoutFeedback onPress={toggleRepeatMode}>
            <MaterialIcons
              name={repeatMode === RepeatMode.Off ? 'repeat' : (repeatMode === RepeatMode.Track ? 'repeat-one' : 'repeat')}
              size={30}
              style={{ color: repeatMode !== RepeatMode.Off ? "#ff7700" : colors.text }}
            />
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