import { defaultStyles } from '@/styles';
import { Stack } from 'expo-router';
import { View } from 'react-native';
import { StackScreenWithSearchBar } from '@/constants/layout';

const PlaylistsLayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen 
          name="index" 
          options={{ 
          ...StackScreenWithSearchBar,
          title: 'Playlists', 
          headerShown: false }} />
        <Stack.Screen 
        name="[id]" 
        options={{ 
        ...StackScreenWithSearchBar,
        title: 'Playlist', 
        headerShown: false }} />
      </Stack>
    </View>
  );
}

export default PlaylistsLayout;