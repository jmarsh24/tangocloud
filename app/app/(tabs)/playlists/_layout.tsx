import React from 'react';
import { Stack } from 'expo-router';

export default function _layout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Playlists', headerShown: false }} />
      <Stack.Screen name="[id]" options={{ title: 'Playlist', headerShown: false }} />
    </Stack>
  );
}