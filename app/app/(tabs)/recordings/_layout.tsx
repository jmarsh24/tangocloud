import React from 'react';
import { Stack } from 'expo-router';

export default function _layout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Recordings', headerShown: false }} />
      <Stack.Screen name="[id]" options={{ title: 'Recording', headerShown: false }} />
    </Stack>
  );
}