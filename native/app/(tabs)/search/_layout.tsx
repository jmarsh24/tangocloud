import React from 'react';
import { Stack } from 'expo-router';
import { View } from 'react-native';
import { defaultStyles } from '@/styles';
import { StackScreenWithSearchBar } from '@/constants/layout';

const SearchLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen
          name="index"
          options={{
          ...StackScreenWithSearchBar,
          title: 'Search' }}
        />
      </Stack>
    </View>
  );
}

export default SearchLayout;
