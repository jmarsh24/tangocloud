import React from "react";
import { Stack } from "expo-router";
import { View } from "react-native";
import { defaultStyles } from "@/styles";
import { StackScreenWithSearchBar } from "@/constants/layout";

export default function _layout() {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen 
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Singers', 
          headerShown: false }} 
        />
      </Stack>
    </View>
  )
};