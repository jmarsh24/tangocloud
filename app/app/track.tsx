  import React, { useEffect, useRef } from 'react';
  import { StyleSheet, View, Text, Image, Animated, Dimensions, Pressable } from 'react-native';
  import { useTheme } from '@react-navigation/native';
  import { usePlayerContext } from '@/providers/PlayerProvider';
  import { PlayerControls } from '@/components/PlayerControls';

  export default function trackScreen() {
    const vinylRecordImg = require('@/assets/images/vinyl_3x.png');
    const vinylArmImg = require('@/assets/images/vinyl-arm.png');
    const { track, playTrack, pauseTrack, isPlaying } = usePlayerContext();
    const { colors } = useTheme();
    const styles = getStyles(colors); 

    const onPlayPause = async () => {
      if (isPlaying) {
        await pauseTrack();
      } else {
        await playTrack();
      }
    };

    const screenWidth = Dimensions.get('window').width;
    const spinValue = useRef(new Animated.Value(0)).current;
    const armRotation = useRef(new Animated.Value(0)).current;

    useEffect(() => {
      let animation = Animated.loop(
        Animated.timing(spinValue, {
          toValue: 1,
          duration: 33000,
          useNativeDriver: true,
        })
      );
      if (isPlaying) {
        animation.start();
      } else {
        animation.stop();
      }

      return () => animation.stop();
    }, [isPlaying, spinValue]);

    const spin = spinValue.interpolate({
      inputRange: [0, 1],
      outputRange: ['0deg', '360deg'],
    });

    const armRotate = armRotation.interpolate({
      inputRange: [0, 1],
      outputRange: ['0deg', '25deg'], // Adjust based on how much you want the arm to rotate
    });

    const vinylSize = screenWidth * 0.8;
    const albumArtSize = vinylSize * 0.36;

  return (
      <View style={styles.container}>
        <Animated.Image 
        source={vinylArmImg}
        style={styles.arm}
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
        <Image 
          source={{ uri: track?.albumArtUrl }}
          style={[styles.albumArt, { 
            width: albumArtSize, 
            height: albumArtSize, 
            borderRadius: albumArtSize / 2,
            top: (vinylSize - albumArtSize) / 2,
            left: (vinylSize - albumArtSize) / 2,
          }]} 
        />
      </Animated.View>

        <View style={styles.trackInfo}>
          <Text style={styles.title}>{track.title}</Text>
          {track?.orchestra?.name && <Text style={styles.subtitle}>{track.orchestra.name}</Text>}
          {track?.singers?.[0]?.name && <Text style={styles.subtitle}>{track.singers[0].name}</Text>}
          {track?.lyricist?.name && <Text style={styles.subtitle}>{track.lyricist.name}</Text>}
          {track?.composer?.name && <Text style={styles.subtitle}>{track.composer.name}</Text>}
          <View style={styles.row}>
            {track?.genre?.name && <Text style={styles.subtitle}>{track.genre.name}</Text>}
            {track?.recordedDate && <Text style={styles.subtitle}>{track.recordedDate}</Text>}
          </View>
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