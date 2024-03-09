import React from 'react';
import { Stack } from 'expo-router';

const Layout = () => {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Playlists' }} />
      <Stack.Screen name="[id]" options={{ title: 'Playlist' }} />
    </Stack>
  );
}

export default Layout;