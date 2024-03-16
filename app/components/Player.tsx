import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Image, Text, Pressable } from 'react-native';
import { Link } from 'expo-router';
import TrackPlayer, { Event } from 'react-native-track-player';
import { PlayPauseButton } from '@/components/PlayPauseButton';
import { useTheme } from '@react-navigation/native';
import { FontAwesome6 } from '@expo/vector-icons';

const Player = () => {
  const [track, setTrack] = useState(null);
  const { colors } = useTheme();

  useEffect(() => {
    const fetchCurrentTrack = async () => {
      let trackIndex = await TrackPlayer.getActiveTrackIndex();
      if (trackIndex !== undefined) {
        let trackObject = await TrackPlayer.getTrack(trackIndex);
        setTrack(trackObject);
      } else {
        setTrack(null);
      }
    };

    fetchCurrentTrack();

    const onTrackChange = TrackPlayer.addEventListener(Event.PlaybackActiveTrackChanged, async () => {
        let trackIndex = await TrackPlayer.getActiveTrackIndex();
        let trackObject = await TrackPlayer.getTrack(trackIndex);
        setTrack(trackObject);
      }
    );

    return () => {
      onTrackChange.remove();
    };
  }, []);

  if (!track) {
    return null;
  }

  return (
    <View style={[styles.container, { backgroundColor: colors.card }]}>
      <Link href={{ pathname: "/player/[id]", params: { id: track.id } }}>
        <View style={styles.player}>
          <Image source={{ uri: track?.artwork }} style={styles.image} />
          <View style={styles.info}>
            <Text style={[styles.title, { color: colors.text }]}>{track?.title}</Text>
            <Text style={[ styles.subtitle, { color: colors.text }]}>{track?.artist}</Text>
          </View>
          <PlayPauseButton size={24} />
          <Pressable onPress={TrackPlayer.skipToNext()}>
            <FontAwesome6 name={'forward'} size={24} style={{ color: colors.text }} />
          </Pressable>
        </View>
      </Link>
    </View>
  );
};

export default Player;


const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    width: '100%',
    bottom: 80
  },
  player: {
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.22,
    shadowRadius: 2.22,
    padding: 10,
    paddingRight: 20,
  },
  image: {
    width: 64,
    height: 64,
    marginRight: 10,
    borderRadius: 5,
  },
  info: {
    flex: 1,
  },
  title: {
    fontSize: 16,
  },
  subtitle: {
    fontSize: 12,
  },
});