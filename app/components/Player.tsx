import React, { useEffect } from 'react';
import { View, Text, StyleSheet, Image } from 'react-native';
import { Link } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { usePlayerContext } from '@/providers/PlayerProvider';
import Colors from '@/constants/Colors';

const Player = () => {
  const { track, playTrack, pauseTrack, isPlaying } = usePlayerContext();

  useEffect(() => {
    playTrack();
  }, [track]);

  const onPlayPause = async () => {
    if (isPlaying) {
      await pauseTrack();
    } else {
      await playTrack();
    }
  };

  if (!track) {
    return null;
  }

  return (
    <View style={styles.container}>
      <Link href="/track">
        <View style={styles.player}>
          <Image source={{ uri: track.albumArtUrl }} style={styles.image} />
          <View style={styles.info}>
            <Text style={styles.title}>{track.title}</Text>
            <Text style={styles.subtitle}>{track?.orchestra.name}</Text>
            <View style={{ flexDirection: 'row' }}>
              <Text style={styles.subtitle}>{track?.recordedDate}</Text>
              <Text style={styles.subtitle}>{track?.genre.name}</Text>
            </View>
          </View>

          <Ionicons
            onPress={onPlayPause}
            disabled={false}
            name={isPlaying ? 'pause' : 'play'}
            size={22}
            color={track ? Colors.light.text : Colors.light.tint }
          />
        </View>
      </Link>
    </View>
  );
};

const styles = StyleSheet.create({
   container: {
    position: 'absolute',
    width: '100%',
    bottom: 80,
    padding: 10,
  },
  player: {
    width: '100%',
    backgroundColor: '#1C1C1E',
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 10,
    paddingHorizontal: 15,
    paddingVertical: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.22,
    shadowRadius: 2.22,
  },
  title: {
    color: Colors.dark.text,
    fontSize: 16,
    fontWeight: 'bold',
  },
  subtitle: {
    color: Colors.dark.text,
    fontSize: 12,
  },
  image: {
    width: 50,
    height: 50,
    marginRight: 10,
    borderRadius: 5,
  },
  info: {
    flex: 1, // Take up all available space after the image
  },
});

export default Player;