import React from 'react';
import { Stack } from 'expo-router';

const Layout = () => {
  return (
    <Stack>
      <Stack.Screen name="orchestras" options={{ headerShown: false }} />
      {/* <Stack.Screen name="composers" options={{ headerShown: false }} />
      <Stack.Screen name="lyricists" options={{ headerShown: false }} />
      <Stack.Screen name="periods" options={{ headerShown: false }} />
      <Stack.Screen name="singers" options={{ headerShown: false }} /> */}
    </Stack>
  );
};

export default Layout;