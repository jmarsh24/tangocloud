import React from 'react';
import { Stack } from 'expo-router';

export default function _layout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Search', headerShown: false }} />
      <Stack.Screen name="[id]" options={{ title: 'Search', headerShown: false }} />
    </Stack>
  );
}