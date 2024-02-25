import React, { useEffect } from 'react';
import FontAwesome from '@expo/vector-icons/FontAwesome';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { useFonts } from 'expo-font';
import { SplashScreen, Stack } from 'expo-router';
import { useColorScheme } from 'react-native';
import { AuthProvider } from '@/providers/AuthProvider';
import ApolloClientProvider from '@/providers/ApolloClientProvider';
import { SetupService } from '@/services/SetupService';
import { PlaybackService } from '@/services/PlaybackService';
import TrackPlayer from 'react-native-track-player';

export {
  ErrorBoundary,
} from 'expo-router';

export const unstable_settings = {
  initialRouteName: '(tabs)',
};

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded, error] = useFonts({
    SpaceMono: require('@/assets/fonts/SpaceMono-Regular.ttf'),
    ...FontAwesome.font,
  });

  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    async function initializeApp() {
      try {
        // Register the playback service before anything else
        TrackPlayer.registerPlaybackService(() => PlaybackService);

        // Setup the TrackPlayer
        await SetupService();

        // Hide the SplashScreen after everything is initialized
        if (loaded) {
          await SplashScreen.hideAsync();
        }
      } catch (error) {
        console.error("Initialization failed: ", error);
      }
    }

    initializeApp();
  }, [loaded]);

  if (!loaded) {
    return null;
  }

  return <RootLayoutNav />;
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
            <Stack.Screen name="recording" options={{ presentation: 'modal', headerShown: false }} />
          </Stack>
        </AuthProvider>
      </ApolloClientProvider>
    </ThemeProvider>
  );
}