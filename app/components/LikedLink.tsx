import React from 'react';
import { Text, View, StyleSheet, Image } from 'react-native';
import { useTheme } from '@react-navigation/native';
import { Link } from 'expo-router';

export default function LikedLink() {
  const { colors } = useTheme();
  
  return (
    <Link href="/library" >
      <View style={styles.playlistContainer}>
        <Image source={require('@/assets/images/playlist_liked.jpeg')} style={styles.playlistImage} />
        <View style={styles.playlistInfo}>
          <Text style={[styles.playlistTitle, { color: colors.text }]}>
            Liked
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
    padding: 10,
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