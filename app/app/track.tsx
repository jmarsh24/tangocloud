import React, { useState, useEffect, useRef } from 'react';
import { StyleSheet, View, Text, Image, Animated, Dimensions } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer from 'react-native-track-player';
import { PlayerControls } from '@/components/PlayerControls';
import { Progress } from '@/components/Progress';
import { Spacer } from '@/components/Spacer';
import { TrackInfo } from '@/components/TrackInfo';

export default function TrackScreen() {
  const vinylRecordImg = require('@/assets/images/vinyl_3x.png');
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const [track, setTrack] = useState(null);

  useEffect(() => {
    const fetchCurrentTrack = async () => {
      let trackIndex = await TrackPlayer.getActiveTrackIndex();
      let trackObject = await TrackPlayer.getTrack(trackIndex);
      setTrack(trackObject);
    };

    fetchCurrentTrack();
  }, []);

  const screenWidth = Dimensions.get('window').width;
  const vinylSize = screenWidth * 0.8;
  const albumArtSize = vinylSize * 0.36;

  return (
    <View style={styles.container}>
      <Animated.View
        style={[
          styles.vinyl,
          { width: vinylSize, height: vinylSize }
        ]}
      >
        <Image
          source={vinylRecordImg}
          style={[styles.vinylImg, { width: vinylSize, height: vinylSize }]}
        />
        <Image
          source={{ uri: track?.artwork || '' }}
          style={[
            styles.albumArt,
            {
              width: albumArtSize,
              height: albumArtSize,
              borderRadius: albumArtSize / 2,
              top: (vinylSize - albumArtSize) / 2,
              left: (vinylSize - albumArtSize) / 2,
            },
          ]}
        />
      </Animated.View>
      <View style={styles.controls}>
        <TrackInfo track={track} />
        <Progress />
        <Spacer />
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
        display: 'flex',
        alignItems: 'center',
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