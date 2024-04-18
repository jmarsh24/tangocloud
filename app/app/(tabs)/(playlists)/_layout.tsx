import { defaultStyles } from '@/styles';
import { Stack } from 'expo-router';
import { View } from 'react-native';

const PlaylistsScreenlayout = () => {
  return (
    <View style={defaultStyles.container}>
      <Stack>
        <Stack.Screen name="index" options={{ title: 'Playlists', headerShown: false }} />
        <Stack.Screen name="[id]" options={{ title: 'Playlist', headerShown: false }} />
      </Stack>
    </View>
  );
}

export default PlaylistsScreenlayout;