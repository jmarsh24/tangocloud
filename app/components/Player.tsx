import { View, Text, StyleSheet, Image } from 'react-native';
import { Link } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { usePlayerContext } from '@/providers/PlayerProvider';
import { useEffect, useState } from 'react';
import { AVPlaybackStatus, Audio } from 'expo-av';
import { Sound } from 'expo-av/build/Audio';
import Colors from '@/constants/Colors';

const Player = () => {
  const [sound, setSound] = useState<Sound>();
  const [isPlaying, setIsPlaying] = useState(false);
  const { track } = usePlayerContext();


  useEffect(() => {
    if (!track) {
      return;
    }
    playTrack();
  }, [track]);

useEffect(() => {
    const setAudioMode = async () => {
      try {
        await Audio.setAudioModeAsync({
          playsInSilentModeIOS: true,
          shouldDuckAndroid: true,
          staysActiveInBackground: true,
        });
      } catch (e) {
        console.log(e);
      }
    };

    setAudioMode();
  }, []);

  const playTrack = async () => {
    if (sound) {
      await sound.unloadAsync();
    }

    const { sound: newSound } = await Audio.Sound.createAsync({
      uri: "https://pub-10ab067adc844f51b24c57dee2e3e3ce.r2.dev/sample_audio_mp3_amarras.mp3",
    });

    setSound(newSound);
    newSound.setOnPlaybackStatusUpdate(onPlaybackStatusUpdate);
    await newSound.playAsync();
  };

  const onPlaybackStatusUpdate = (status: AVPlaybackStatus) => {
    if (!status.isLoaded) {
      return;
    }

    setIsPlaying(status.isPlaying);
  };

  const onPlayPause = async () => {
    if (!sound) {
      return;
    }
    if (isPlaying) {
      await sound.pauseAsync();
    } else {
      await sound.playAsync();
    }
  };

  if (!track || !track.title) {
    return null; // Don't render the player if there is no track or track title
  }

  return (
    <View style={styles.container}>
      <Link href="/track">
        <View style={styles.player}>
          <Image source={require('@/assets/images/album_art.jpg')} style={styles.image} />
          <View style={styles.info}>
            <Text style={styles.title}>{track?.title}</Text>
            <Text style={styles.subtitle}>{track?.orchestra}</Text>
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
    top: -90,
    padding: 10,
  },
  player: {
    backgroundColor: "#1B137D",
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 5,
    paddingHorizontal: 15,
    paddingVertical: 10,
    width: '100%',
  },
  title: {
    color: Colors.light.text,
  },
  subtitle: {
    color: Colors.light.text,
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