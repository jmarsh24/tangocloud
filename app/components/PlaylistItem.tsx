import React from 'react';
import { Text, View, StyleSheet, Image } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function PlaylistItem({ playlist }) {
  const { colors } = useTheme();
  
  return (
    <Link href={`/playlists/${playlist.id}`} >
      <View style={styles.playlistContainer}>
        <Image source={{ uri: playlist.imageUrl }} style={styles.playlistImage} />
        <View style={styles.playlistInfo}>
          <Text style={[styles.playlistTitle, { color: colors.text }]}>
            {playlist.title}
          </Text>
        </View>
      </View>
    </Link>
  );
}

const styles = StyleSheet.create({
  playlistContainer: {
    display: 'flex',
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    padding: 4,
  },
  playlistTitle: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  playlistImage: {
    width: 100,
    height: 100,
  },
  playlistInfo: {
  },
});