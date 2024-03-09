import Slider from '@react-native-community/slider';
import React, { useEffect, useState } from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import TrackPlayer, { useProgress } from 'react-native-track-player';
import { useTheme } from '@react-navigation/native';

export const Progress: React.FC = () => {
  const { position} = useProgress();
  const { colors } = useTheme();
  const [duration, setDuration] = useState(0);

  useEffect(() => {
    const fetchCurrentTrack = async () => {
      const trackIndex = await TrackPlayer.getActiveTrackIndex();

      if (trackIndex !== null && trackIndex !== undefined) {
        const track = await TrackPlayer.getTrack(trackIndex);
        setDuration(track?.duration || 0);
      }
    };

    fetchCurrentTrack();
  }, []);


  const progressBarWidth = Dimensions.get('window').width * 0.92;

  return (
    <View style={styles.container}>
      <Slider
        style={{ ...styles.slider, width: progressBarWidth }}
        value={position}
        minimumValue={0}
        maximumValue={duration}
        thumbTintColor={"#ff7700"}
        minimumTrackTintColor={"#ff7700"}
        maximumTrackTintColor={"#ffffff"}
        onSlidingComplete={TrackPlayer.seekTo}
      />
      <View style={styles.labelContainer}>
        <Text style={[styles.labelText, { color: colors.text }]}>{formatSeconds(position)}</Text>
        <Text style={[styles.labelText, { color: colors.text }]}>
          {formatSeconds(Math.max(0, duration - position))}
        </Text>
      </View>
    </View>
  );
};

const formatSeconds = (time: number) =>
  new Date(time * 1000).toISOString().slice(14, 19);

const styles = StyleSheet.create({
  container: {
    height: 80,
    width: '90%',
    alignItems: 'center',
    justifyContent: 'center',
  },
  liveText: {
    fontSize: 18,
    alignSelf: 'center',
  },
  slider: {
    height: 40,
    flexDirection: 'row',
  },
  labelContainer: {
    width: '100%',
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  labelText: {
    fontVariant: ['tabular-nums'],
  },
});