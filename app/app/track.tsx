import React, { useState, useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, Animated, Dimensions, Pressable } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer, { usePlaybackState, useTrackPlayerEvents, Event, State } from 'react-native-track-player';
import { PlayerControls } from '@/components/PlayerControls';

export default function TrackScreen() {
  const vinylRecordImg = require('@/assets/images/vinyl_3x.png');
  const vinylArmImg = require('@/assets/images/vinyl-arm.png');
  const { colors } = useTheme();
  const styles = getStyles(colors); 

  const playbackState = usePlaybackState();
  const [track, setTrack] = useState<Track | null>(null);
  const isPlaying = playbackState === State.Playing;

  // Animation refs
  const spinValue = useRef(new Animated.Value(0)).current;
  const armRotation = useRef(new Animated.Value(0)).current;

  // Fetch current track details
  useEffect(() => {
    const fetchCurrentTrack = async () => {
      const currentTrackId = await TrackPlayer.getCurrentTrack();
      if (currentTrackId !== null) {
        const currentTrack = await TrackPlayer.getTrack(currentTrackId);
        setTrack(currentTrack);
      }
    };

    fetchCurrentTrack();
  }, []);

  // Animation for vinyl spin
  useEffect(() => {
    Animated.loop(
      Animated.timing(spinValue, {
        toValue: 1,
        duration: 33000,
        useNativeDriver: true,
      })
    ).start();
  }, [spinValue]);

  // Animation for arm rotation based on playback state
  useEffect(() => {
    Animated.timing(armRotation, {
      toValue: isPlaying ? 1 : 0,
      duration: 500,
      useNativeDriver: true,
    }).start();
  }, [isPlaying, armRotation]);

  const spin = spinValue.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg'],
  });

  const armRotate = armRotation.interpolate({
    inputRange: [0, 1],
    outputRange: ['-30deg', '0deg'], // Adjust based on your vinyl arm's starting position
  });

  const screenWidth = Dimensions.get('window').width;
  const vinylSize = screenWidth * 0.8;
  const albumArtSize = vinylSize * 0.36;

  return (
    <View style={styles.container}>
      <Animated.Image 
        source={vinylArmImg}
        style={[styles.arm, { transform: [{ rotate: armRotate }] }]}
      />
      <Animated.View style={[styles.vinyl, { 
        width: vinylSize, 
        height: vinylSize, 
        transform: [{ rotate: spin }]
      }]}>
        <Image 
          source={vinylRecordImg}
          style={[styles.vinylImg, { 
            width: vinylSize, 
            height: vinylSize
          }]} 
        />
        {track && <Image 
          source={{ uri: track.artwork || '' }} // Fallback URL or local image if artwork is null
          style={[styles.albumArt, { 
            width: albumArtSize, 
            height: albumArtSize, 
            borderRadius: albumArtSize / 2,
            top: (vinylSize - albumArtSize) / 2,
            left: (vinylSize - albumArtSize) / 2,
          }]} 
        />}
      </Animated.View>

      <View style={styles.trackInfo}>
        <Text style={styles.title}>{track?.title || 'Unknown Track'}</Text>
        <Text style={styles.subtitle}>{track?.artist || 'Unknown Artist'}</Text>
        {/* Additional track info here */}
      </View>

      <View style={styles.controls}>
        <PlayerControls />
      </View>
    </View>
  );
}

  function getStyles(colors) {
    return StyleSheet.create({
      container: {
        flex: 1,
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: 100,
        backgroundColor: colors.background, // Use theme color for background
      },
      subtitle: {
        color: colors.text, // Use theme color for text
        fontSize: 12,
      },
      row: {
        display: 'flex',
        gap: 10,
        flexDirection: 'row',
        alignItems: 'center',
      },
      vinylImg: {
        position: 'absolute', 
        justifyContent: 'center',
        alignItems: 'center'
      },
      arm: {
        position: 'absolute',
        width: 30, 
        right: 50, 
        top: -100, 
        zIndex: 3,
        transform: [
          { rotate: '5deg' }, 
          { scale: 0.5 }, 
        ],
        overflow: 'visible',
      },
      albumArt: {
        position: 'absolute',
        justifyContent: 'center',
        alignItems: 'center',
        zIndex: 2,
      },
      trackInfo: {
        alignItems: 'center',
      },
      title: {
        fontSize: 24,
        fontWeight: 'bold',
        marginBottom: 4,
        color: colors.text,
      },
      artist: {
        fontSize: 18,
        color: colors.text,
      },
      controls: {
        flexDirection: 'row',
        justifyContent: 'space-around',
        width: '100%',
        paddingHorizontal: 50,
        paddingBottom: 20,
      },
      playButtonContainer: {
        backgroundColor: colors.buttonSecondary,
        borderRadius: 35,
        width: 70,
        height: 70,
        justifyContent: 'center',
        alignItems: 'center',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.25,
        shadowRadius: 3.84
      },
    });
  }