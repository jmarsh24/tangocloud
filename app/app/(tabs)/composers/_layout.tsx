import React from "react";
import { Stack } from "expo-router";

const ComposersLayout = () => {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: 'Composers' }} />
      <Stack.Screen name="[id]" options={{ title: 'Composer' }} />
    </Stack>
  )
};

export default ComposersLayout;