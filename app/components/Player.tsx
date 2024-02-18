import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Image } from 'react-native';
import { Link } from 'expo-router';
import TrackPlayer, { Event } from 'react-native-track-player';
import { PlayPauseButton } from '@/components/PlayPauseButton';
import { TrackInfo } from '@/components/TrackInfo';
import { useTheme } from '@react-navigation/native';

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
      padding: 10,
    },
    player: {
      width: '100%',
      backgroundColor: colors.background,
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
    image: {
      width: 50,
      height: 50,
      marginRight: 10,
      borderRadius: 5,
    },
    info: {
      flex: 1,
    },
  });

  return (
    <View style={dynamicStyles.container}>
      <Link href="/track">
        <View style={dynamicStyles.player}>
          <Image source={{ uri: track?.artwork }} style={dynamicStyles.image} />
          <View style={dynamicStyles.info}>
            <TrackInfo track={track} />
          </View>
          <PlayPauseButton />
        </View>
      </Link>
    </View>
  );
};

export default Player;