import React, { createContext, useState, useContext, useEffect, PropsWithChildren } from 'react';
import { Audio } from 'expo-av';
import * as SecureStore from 'expo-secure-store';
import { Track } from '@/types'; // Assuming you have a Track type defined

const PlayerContext = createContext({
  track: undefined,
  setTrack: (track: Track) => {},
  playTrack: () => {},
  pauseTrack: () => {},
  isPlaying: false,
});

async function getAuthToken(): Promise<string | null> {
  return await SecureStore.getItemAsync('token');
}

export default function PlayerProvider({ children }: PropsWithChildren) {
  const [track, setTrack] = useState<Track>();
  const [sound, setSound] = useState<Audio.Sound>();
  const [isPlaying, setIsPlaying] = useState(false);

  useEffect(() => {
    return sound
      ? () => {
          console.log('Unloading Sound');
          sound.unloadAsync();
        }
      : undefined;
  }, [sound]);

  useEffect(() => {
    const setAudioMode = async () => {
      await Audio.setAudioModeAsync({
        playsInSilentModeIOS: true,
        shouldDuckAndroid: true,
        staysActiveInBackground: true,
      });
    };

    setAudioMode();
  }, []);

  const playTrack = async () => {
    if (!track) return;

    const audioUrl = track.audios[0].url;
    if (sound) {
      await sound.unloadAsync();
    }
    if (!audioUrl) return;

    const authToken = await getAuthToken();
    const source = {
      uri: audioUrl,
      headers: {
        Authorization: authToken ? `Bearer ${authToken}` : '',
      },
    };

    const { sound: newSound } = await Audio.Sound.createAsync(source);
    setSound(newSound);
    newSound.setOnPlaybackStatusUpdate((status) => setIsPlaying(status.isPlaying));
    await newSound.playAsync();
  };

  const pauseTrack = async () => {
    if (sound && isPlaying) {
      await sound.pauseAsync();
    }
  };

  const providerValue = {
    track,
    setTrack,
    playTrack,
    pauseTrack,
    isPlaying,
  };

  return <PlayerContext.Provider value={providerValue}>{children}</PlayerContext.Provider>;
};

export const usePlayerContext = () => useContext(PlayerContext);