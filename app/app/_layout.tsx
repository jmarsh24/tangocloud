import React, { useEffect } from "react";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import {
  DarkTheme,
  DefaultTheme,
  ThemeProvider,
} from "@react-navigation/native";
import { useFonts } from "expo-font";
import { SplashScreen, Stack } from "expo-router";
import { AuthProvider } from "@/providers/AuthProvider";
import ApolloClientProvider from "@/providers/ApolloClientProvider";
import { SetupService } from "@/services/SetupService";
import { PlaybackService } from "@/services/PlaybackService";
import TrackPlayer from "react-native-track-player";
import { SafeAreaProvider } from "react-native-safe-area-context";
export { ErrorBoundary } from "expo-router";
import "@/global.css";
import { useColorScheme } from "nativewind";
import { StatusBar } from "expo-status-bar";

export const unstable_settings = {
  initialRouteName: "(tabs)",
};

SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const [loaded, error] = useFonts({
    SpaceMono: require("@/assets/fonts/SpaceMono-Regular.ttf"),
    ...FontAwesome.font,
  });

  useEffect(() => {
    if (error) throw error;
  }, [error]);

  useEffect(() => {
    async function initializeApp() {
      try {
        TrackPlayer.registerPlaybackService(() => PlaybackService);

        await SetupService();

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

  return (
    <SafeAreaProvider>
      <RootLayoutNav />
    </SafeAreaProvider>
  );
}

function RootLayoutNav() {
  const colorScheme = useColorScheme();

  return (
    <ThemeProvider value={colorScheme === "dark" ? DarkTheme : DefaultTheme}>
      <ApolloClientProvider>
        <AuthProvider>
          <Stack
            screenOptions={{
              headerStyle: {
                backgroundColor: "#f472b6",
              },
              contentStyle: {
                backgroundColor: colorScheme == "dark" ? "#09090B" : "#FFFFFF",
              },
            }}
          >
            <Stack.Screen name="(auth)" options={{ headerShown: false }} />
            <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
            <Stack.Screen
              name="player/[id]"
              options={{ presentation: "modal", headerShown: false }}
            />
            <StatusBar />
          </Stack>
        </AuthProvider>
      </ApolloClientProvider>
    </ThemeProvider>
  );
}
