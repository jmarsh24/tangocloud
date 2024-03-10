import React from "react";
import { Stack } from "expo-router";

const SingersLayout = () => {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Singers' }} />
      <Stack.Screen name="[id]" options={{ title: 'Singer' }} />
    </Stack>
  )
};

export default SingersLayout;