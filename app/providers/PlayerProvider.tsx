import React, { createContext, useContext, PropsWithChildren } from 'react';

const PlayerContext = createContext({
  // track: undefined,
  // setTrack: (track: Track) => {},
  // playTrack: () => {},
  // pauseTrack: () => {},
  // isPlaying: false,
});

// async function getAuthToken(): Promise<string | null> {
//   return await SecureStore.getItemAsync('token');
// }

export default function PlayerProvider({ children }: PropsWithChildren) {

  const providerValue = {
    // track,
    // setTrack,
    // playTrack,
    // pauseTrack,
    // isPlaying,
  };

  return <PlayerContext.Provider value={providerValue}>{children}</PlayerContext.Provider>;
};

export const usePlayerContext = () => useContext(PlayerContext);