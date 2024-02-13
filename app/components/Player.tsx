import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, Image, Pressable } from 'react-native';
import { Link } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import TrackPlayer, { usePlaybackState, useTrackPlayerEvents, Event, State } from 'react-native-track-player';
import Colors from '@/constants/Colors';
import { PlayPauseButton } from '@/components/PlayPauseButton';

const Player = () => {
  const [track, setTrack] = useState<Track | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const playbackState = usePlaybackState();

  useEffect(() => {
    const fetchCurrentTrack = async () => {
      const currentTrackId = await TrackPlayer.getCurrentTrack();
      if (currentTrackId !== null) {
        const currentTrack = await TrackPlayer.getTrack(currentTrackId);
        setTrack(currentTrack);
      }
    };

    fetchCurrentTrack();
  }, [playbackState]);

  useTrackPlayerEvents([Event.PlaybackTrackChanged], async (event) => {
    if (event.type === Event.PlaybackTrackChanged && event.nextTrack !== null) {
      const track = await TrackPlayer.getTrack(event.nextTrack);
      setTrack(track);
    }
  });

  const onPlayPause = async () => {
    const state = await TrackPlayer.getState();
    if (state == State.Playing) {
      await TrackPlayer.pause();
    } else {
      await TrackPlayer.play();
    }
  };


  if (!track) {
    return null;
  }

  return (
    <View style={styles.container}>
      <Link href="/track">
        <View style={styles.player}>
          <Image source={{ uri: track.artwork }} style={styles.image} />
          <View style={styles.info}>
            <Text style={styles.title}>{track.title}</Text>
            <Text style={styles.subtitle}>{track.artist}</Text>
            {/* Additional track info here */}
          </View>

          <PlayPauseButton />
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