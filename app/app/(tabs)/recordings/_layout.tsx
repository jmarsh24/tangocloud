import React from 'react';
import { Stack } from 'expo-router';
import { View } from 'react-native';
import { defaultStyles } from '@/styles';
import { StackScreenWithSearchBar } from '@/constants/layout';

const RecordingsLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen 
          name="index" 
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Recordings', 
          headerShown: false }} 
        />
          <Stack.Screen 
          name="[id]" 
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Recording', 
          headerShown: false }} 
        />
      </Stack>
    </View>
  );
}

export default RecordingsLayout;