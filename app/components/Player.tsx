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
    playTrack();
  }, [track]);

  useEffect(() => {
    return sound
      ? () => {
          console.log('Unloading Sound');
          sound.unloadAsync();
        }
      : undefined;
  }, [sound]);

  const playTrack = async () => {
    if (sound) {
        await sound.unloadAsync();
    }
    if (track && track.audios && track.audios.length > 0) {
        const audioUrl = track.audios[0].url;
        const headers = {
            Authorization: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZDkyNmJjM2ItYWQ0ZC00MWUwLTkxYzUtZDRiMjhkMDk3NDkzIn0.tX71xEVTt_notixhRZIYpQU8MOYPM_IX-SYQC-neXMo',
        };

        const source = {
            uri: audioUrl,
            headers: headers
        };

        try {
            const { sound: newSound } = await Audio.Sound.createAsync(
                source,
                // Add any initial status options here, if needed
            );

            setSound(newSound);
            newSound.setOnPlaybackStatusUpdate(onPlaybackStatusUpdate);
            await newSound.playAsync();
        } catch (error) {
            console.error('Error creating audio:', error);
        }
    }
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
            <Text style={styles.title}>{track.title}</Text>
            <Text style={styles.subtitle}>{track?.orchestra.name}</Text>
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
    width: '100%',
    bottom: 50,
    padding: 10,
    
  },
  player: {
    width: '100%',
    backgroundColor: "#1B137D",
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: 5,
    paddingHorizontal: 15,
    paddingVertical: 10,
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