import React, { useState, useEffect, useRef } from 'react';
import { StyleSheet, View, Image, Dimensions } from 'react-native';
import { useTheme } from '@react-navigation/native';
import TrackPlayer, { useProgress } from 'react-native-track-player';
import { PlayerControls } from '@/components/PlayerControls';
import { Progress } from '@/components/Progress';
import { TrackInfo } from '@/components/TrackInfo';
import { GET_RECORDING_DETAILS } from '@/graphql';
import { useQuery } from '@apollo/client';
import Waveform from '@/components/Waveform';

export default function TrackScreen() {
  const vinylRecordImg = require('@/assets/images/vinyl_3x.png');
  const { colors } = useTheme();
  const styles = getStyles(colors);
  const [track, setTrack] = useState<any>(null);
  const { position } = useProgress(1);
  const positionRef = useRef(position);
  // Removed duration from useProgress and use a state for track's duration
  const [trackDuration, setTrackDuration] = useState<number>(0); 
  const progressRef = useRef(0);
  const animationFrameRef = useRef<number>();
  const deviceWidth = Dimensions.get('window').width;

  useEffect(() => {
    const fetchCurrentTrack = async () => {
      const trackIndex = await TrackPlayer.getActiveTrackIndex();
      const trackObject = await TrackPlayer.getTrack(trackIndex);
      if (trackObject) {
        setTrack(trackObject);
        // Set track's duration from the track object
        setTrackDuration(trackObject.duration);
      }
    };

    fetchCurrentTrack();
  }, []);

  const { data } = useQuery(GET_RECORDING_DETAILS, {
    variables: { recordingId: track?.id },
    skip: !track?.id,
  });
  const waveformData = data?.getRecordingDetails.waveforms[0].data || [];

  useEffect(() => {
    positionRef.current = position;
  }, [position]);

  useEffect(() => {
    const animateProgress = () => {
      const newProgress = trackDuration > 0 ? positionRef.current / trackDuration : 0;
      progressRef.current = newProgress;
      animationFrameRef.current = requestAnimationFrame(animateProgress);
    };

    animateProgress();

    return () => {
      if (animationFrameRef.current) cancelAnimationFrame(animationFrameRef.current);
    };
  }, [trackDuration]); // Depend on trackDuration for updates

  const screenWidth = Dimensions.get('window').width;
  const vinylSize = screenWidth * 0.8;
  const albumArtSize = vinylSize * 0.36;

  return (
    <View style={styles.container}>
      <View
        style={[
          styles.vinyl,
          { width: vinylSize, height: vinylSize },
        ]}
      >
        <Image
          source={vinylRecordImg}
          style={[styles.vinylImg, { width: vinylSize, height: vinylSize }]}
        />
        <Image
          source={{ uri: track?.artwork }}
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
      </View>
      <View style={styles.controls}>
        <TrackInfo track={track} />
        <Waveform
          data={waveformData}
          width={deviceWidth * 0.92}
          height={50}
          progress={progressRef.current}
        />
        <Progress />
        <PlayerControls />
      </View>
    </View>
  );
};


function getStyles(colors) {
  return StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'space-between',
      alignItems: 'center',
      paddingVertical: 100,
      backgroundColor: colors.background,
    },
    subtitle: {
      color: colors.text,
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
      gap: 20,
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