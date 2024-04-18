import { useEffect, useCallback } from 'react';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { useColorScheme, StatusBar } from 'react-native';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { Stack, SplashScreen } from 'expo-router';
import { useFonts } from 'expo-font';
import TrackPlayer from 'react-native-track-player';
import FontAwesome from '@expo/vector-icons/FontAwesome';

import { playbackService } from '@/constants/playbackService';
import { useLogTrackPlayerState } from '@/hooks/useLogTrackPlayerState';
import { useSetupTrackPlayer } from '@/hooks/useSetupTrackPlayer';
import ApolloClientProvider from '@/providers/ApolloClientProvider';
import { AuthProvider } from '@/providers/AuthProvider';

export {
  ErrorBoundary,
} from 'expo-router';

export const unstable_settings = {
  initialRouteName: '(tabs)',
};

SplashScreen.preventAutoHideAsync();

TrackPlayer.registerPlaybackService(() => playbackService)

const App = () => {

  const [fontsLoaded, fontsError] = useFonts({
    SpaceMono: require('@/assets/fonts/SpaceMono-Regular.ttf'),
    ...FontAwesome.font,
  });

  const colorScheme = useColorScheme();
  const statusBarStyle = colorScheme === 'dark' ? 'light-content' : 'dark-content';

  const handleTrackPlayerLoaded = useCallback(() => {
    SplashScreen.hideAsync()
  }, []);

  useSetupTrackPlayer({
    onLoad: handleTrackPlayerLoaded,
  });

  useLogTrackPlayerState();

  useEffect(() => {
    if (fontsError) throw fontsError;
    if (fontsLoaded) SplashScreen.hideAsync();
  }, [fontsLoaded, fontsError]);

  if (!fontsLoaded) {
    return null;
  }

  return (
    <SafeAreaProvider>
      <GestureHandlerRootView style={{ flex: 1 }}>
        <RootLayoutNav />

        <StatusBar barStyle={statusBarStyle} />
      </GestureHandlerRootView>
    </SafeAreaProvider>
  );
}

function RootLayoutNav() {
  const colorScheme = useColorScheme();

  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <ApolloClientProvider>
        <AuthProvider>
          <Stack>
            <Stack.Screen name="(auth)" options={{ headerShown: false }} />
            <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
            <Stack.Screen name="player/[id]" options={{ presentation: 'modal', headerShown: false }} />
          </Stack>
        </AuthProvider>
      </ApolloClientProvider>
    </ThemeProvider>
  );
}

export default App;