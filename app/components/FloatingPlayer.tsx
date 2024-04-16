import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Image, Text, Pressable, Dimensions } from 'react-native';
import { Link } from 'expo-router';
import TrackPlayer, { Event } from 'react-native-track-player';
import { PlayPauseButton } from '@/components/PlayPauseButton';
import { useTheme } from '@react-navigation/native';
import { FontAwesome6 } from '@expo/vector-icons';

const performSkipToNext = () => TrackPlayer.skipToNext();

const FloatingPlayer = () => {
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
            <Text style={[styles.title, { color: colors.text }]}>{track?.title.substring(0, 25)}</Text>
            <Text style={[styles.subtitle, { color: colors.text }]}>{track?.artist.substring(0, 35)}</Text>
            {/* <MovingText style={[styles.title, { color: colors.text }]} text={track?.title} animationThreshold={25} />
            <MovingText style={[styles.subtitle, { color: colors.text }]} text={track?.artist} animationThreshold={35} /> */}
          </View>
          <View style={styles.buttons}>
            <PlayPauseButton size={24} />
            <Pressable onPress={performSkipToNext}>
              <FontAwesome6 name={'forward'} size={24} style={{ color: colors.text }} />
            </Pressable>
          </View>
        </View>
      </Link>
    </View>
  );
};

export default FloatingPlayer;


const styles = StyleSheet.create({
  container: {
    width: Dimensions.get('window').width,
    borderRadius: 12,
    paddingVertical: 10,
  },
  player: {
    display: 'flex',
    width: '100%',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderRadius: 10,
    padding: 10,
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
  buttons: {
    display: 'flex',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  title: {
    fontSize: 16,
  },
  subtitle: {
    fontSize: 12,
  },
});