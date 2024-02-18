import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import type { Track } from 'react-native-track-player';

export const TrackInfo: React.FC<{
  track?: Track;
}> = ({ track }) => {
  const { colors } = useTheme(); // Use the current theme colors

  // Update styles to use theme colors
  const styles = StyleSheet.create({
    container: {
      alignItems: 'center',
    },
    titleText: {
      fontSize: 18,
      fontWeight: '600',
      color: colors.text, // Use theme color
      marginTop: 30,
    },
    artistText: {
      fontSize: 16,
      fontWeight: '200',
      color: colors.text, // Use theme color
    },
  });

  return (
    <View style={styles.container}>
      <Text style={styles.titleText}>{track?.title}</Text>
      <Text style={styles.artistText}>{track?.artist}</Text>
    </View>
  );
};