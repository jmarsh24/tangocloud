import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Image, Text, Pressable } from 'react-native';
import { Link } from 'expo-router';
import TrackPlayer, { Event } from 'react-native-track-player';
import { PlayPauseButton } from '@/components/PlayPauseButton';
import { useTheme } from '@react-navigation/native';
import { FontAwesome6 } from '@expo/vector-icons';

const performSkipToNext = () => TrackPlayer.skipToNext();

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

  // Dynamically adjust styles based on theme
  const dynamicStyles = StyleSheet.create({
    container: {
      position: 'absolute',
      width: '100%',
      bottom: 80,
    },
    player: {
      width: '100%',
      backgroundColor: colors.card,
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
      color: colors.text,
      fontSize: 16,
    },
    subtitle: {
      color: colors.text,
      fontSize: 12,
    },
  });

  return (
    <View style={dynamicStyles.container}>
      <Link href={{
          pathname: "/recordings/[id]",
          params: { id: track.id }
        }}>
        <View style={dynamicStyles.player}>
          <Image source={{ uri: track?.artwork }} style={dynamicStyles.image} />
          <View style={dynamicStyles.info}>
            <Text style={dynamicStyles.title}>{track?.title}</Text>
            <Text style={dynamicStyles.subtitle}>{track?.artist}</Text>
          </View>
          <PlayPauseButton size={24} />
          <Pressable onPress={performSkipToNext}>
            <FontAwesome6 name={'forward'} size={24} style={{ color: colors.text }} />
          </Pressable>
        </View>
      </Link>
    </View>
  );
};

export default Player;