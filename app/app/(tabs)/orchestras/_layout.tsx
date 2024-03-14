import React from "react";
import { Stack } from "expo-router";

export default function _Layout() {
  return (
    <Stack>
      <Stack.Screen name="index" options={{ title: "Orchestras" }} />
      <Stack.Screen name="[id]" options={{ title: "Orchestra" }} />
    </Stack>
  )
};
