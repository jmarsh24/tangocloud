import React from 'react';
import { StyleSheet, TouchableWithoutFeedback, View } from 'react-native';
import TrackPlayer, { useIsPlaying } from 'react-native-track-player';
import FontAwesome6 from 'react-native-vector-icons/FontAwesome6';
import { useTheme } from '@react-navigation/native';

export const PlayPauseButton = ({ size = 48 }) => {
  const { playing, bufferingDuringPlay } = useIsPlaying();
  const { colors } = useTheme();

  const styles = StyleSheet.create({
    container: {
      width: size * 3,
      alignItems: 'center',
      justifyContent: 'center',
    },
    icon: {
      color: colors.text,
    },
  });

  return (
    <View style={styles.container}>
      <TouchableWithoutFeedback onPress={playing ? TrackPlayer.pause : TrackPlayer.play}>
        < FontAwesome6 name={playing ? 'pause' : 'play'} size={size} style={styles.icon} />
      </TouchableWithoutFeedback>
    </View>
  );
};
