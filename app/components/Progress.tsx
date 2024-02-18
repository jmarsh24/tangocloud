import Slider from '@react-native-community/slider';
import React from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import TrackPlayer, { useProgress } from 'react-native-track-player';
import { Spacer } from './Spacer';
import { useTheme } from '@react-navigation/native';

export const Progress: React.FC<{ live?: boolean }> = ({ live }) => {
  const { position, duration } = useProgress();
  const { colors } = useTheme();

  const progressBarWidth = Dimensions.get('window').width * 0.92;

  return (
    <View style={styles.container}>
      {live ? (
        <Text style={[styles.liveText, { color: colors.text }]}>Live Stream</Text>
      ) : (
        <>
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
            <Spacer mode={'expand'} />
            <Text style={[styles.labelText, { color: colors.text }]}>
              {formatSeconds(Math.max(0, duration - position))}
            </Text>
          </View>
        </>
      )}
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
    marginTop: 25,
    flexDirection: 'row',
  },
  labelContainer: {
    flexDirection: 'row',
  },
  labelText: {
    fontVariant: ['tabular-nums'],
  },
});