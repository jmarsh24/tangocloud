import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { useTheme } from '@react-navigation/native';
import type { Track } from 'react-native-track-player';

export const TrackInfo: React.FC<{
  track?: Track;
}> = ({ track }) => {
  const { colors } = useTheme(); 

  return (
    <View style={styles.container}>
      <Text style={[styles.titleText, { color: colors.text} ]}>{track?.title}</Text>
      <Text style={[styles.artistText, { color: colors.text} ]}>{[track?.artist, track?.singer].filter(Boolean).join(' • ')}</Text>
      <Text style={[styles.artistText, { color: colors.text} ]}>{[track?.genre, track?.year].filter(Boolean).join(' • ')}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
  },
  titleText: {
    fontSize: 18,
    fontWeight: '600',
    marginTop: 30,
  },
  artistText: {
    fontSize: 16,
    fontWeight: '200',
  },
});