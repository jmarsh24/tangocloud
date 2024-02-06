import AntDesign from '@expo/vector-icons/AntDesign';
import {DarkTheme, DefaultTheme, ThemeProvider,} from '@react-navigation/native';
import { useFonts } from 'expo-font';
import { SplashScreen, Stack } from 'expo-router';
import { useEffect } from 'react';
import { useColorScheme } from 'react-native';
import PlayerProvider from '@/providers/PlayerProvider';
import ApolloClientProvider from '@/providers/ApolloClientProvider';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Drawer } from 'expo-router/drawer';

export {
  // Catch any errors thrown by the Layout component.
  ErrorBoundary,
} from 'expo-router';

export const unstable_settings = {
  // Ensure that reloading on `/modal` keeps a back button present.
  initialRouteName: '(tabs)',
};

// Prevent the splash screen from auto-hiding before asset loading is complete.
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded, error] = useFonts({
    SpaceMono: require('@/assets/fonts/SpaceMono-Regular.ttf'),
    ...AntDesign.font,
  });

  // Expo Router uses Error Boundaries to catch errors in the navigation tree.
  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    if (loaded) {
      SplashScreen.hideAsync();
    }
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
        <PlayerProvider>
          <Stack>
            <GestureHandlerRootView style={{ flex: 1 }}>
              <Drawer>
                <Drawer.Screen
                  name="index"
                  options={{
                    drawerLabel: 'Home',
                    title: 'overview',
                    
                  }}
                />
                <Drawer.Screen
                  name="user"
                  options={{
                    drawerLabel: 'User',
                    title: 'overview',
                  }}
                />
              </Drawer>
            </GestureHandlerRootView>
            <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
            <Stack.Screen name="modal" options={{ presentation: 'modal' }} />
            <Stack.Screen name="(drawer)/user" options={{ headerShown: false }} />
            <Stack.Screen name="track" options={{ presentation: 'modal' }} />
          </Stack>
        </PlayerProvider>
      </ApolloClientProvider>
    </ThemeProvider>
  );
}