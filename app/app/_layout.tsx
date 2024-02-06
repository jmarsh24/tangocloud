import AntDesign from '@expo/vector-icons/AntDesign';
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native';
import { useFonts } from 'expo-font';
import { SplashScreen, Stack } from 'expo-router';
import React, { useState, useEffect } from 'react';
import { useColorScheme } from 'react-native';
import PlayerProvider from '@/providers/PlayerProvider';
import ApolloClientProvider from '@/providers/ApolloClientProvider';
import { GestureHandlerRootView } from 'react-native-gesture-handler';
import { Drawer } from 'expo-router/drawer';
import { useDatabase } from '../shared/store';
import { ApolloProvider } from '@apollo/client';
import { MockedProvider } from '@apollo/client/testing';
import { Slot, router, useSegments } from 'expo-router';
import { client } from '../model/api';
import { testConfig } from '../test/test-support';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';

// This allows the background image to be visible
const Theme: typeof DefaultTheme = {
  ...DefaultTheme,
  colors: {
    ...DefaultTheme.colors,
    primary: '#fff',
    background: 'transparent',
  },
};

function Providers({ children }: { children: React.ReactNode }): JSX.Element {
  if (testConfig.testing) {
    return <MockedProvider mocks={testConfig.mocks}>{children}</MockedProvider>;
  } else {
    return <ApolloProvider client={client}>{children}</ApolloProvider>;
  }
}

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

  const [checkingLogin, setCheckingLogin] = useState(true);
  const loggedIn = useDatabase((db) => !!db.get('accessToken'));

  const segments = useSegments();
  const authorizedScreen = segments[0] === '(auth)';

  const [rendered, setRendered] = useState(false);

  // const userHadActivity = useAutoLogout({
  //   logout: () => logout({ permanent: false }),
  // });

  useEffect(() => {
    if ((fontsLoaded || fontError) && !checkingLogin) {
      // Hide the splash screen after the fonts have loaded (or an error was returned) and the UI is ready.
      SplashScreen.hideAsync();
      setRendered(true);
    }
  }, [fontsLoaded, fontError, checkingLogin]);

  useEffect(() => {
    startup().finally(() => setCheckingLogin(false));
  }, []);

  useEffect(() => {
    if (!checkingLogin && rendered) {
      if (!loggedIn && (authorizedScreen || segments.length === 0)) {
        router.replace('/login');
      } else if (loggedIn && !authorizedScreen) {
        router.replace('/overview');
      }
    }
  }, [loggedIn, checkingLogin, authorizedScreen, rendered]);
  
function RootLayoutNav() {
  const colorScheme = useColorScheme();

  return (
    <ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
      <StatusBar style="light" />
      <SafeAreaProvider>
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
      </SafeAreaProvider>
    </ThemeProvider>
  );
}
