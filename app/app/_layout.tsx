import { colors } from '@/constants/tokens'
import FontAwesome from '@expo/vector-icons/FontAwesome'
import { DarkTheme, DefaultTheme, ThemeProvider } from '@react-navigation/native'
import { useFonts } from 'expo-font'
import { SplashScreen, Stack } from 'expo-router'
import { useCallback, useEffect } from 'react'
import { StatusBar, useColorScheme } from 'react-native'
import { GestureHandlerRootView } from 'react-native-gesture-handler'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import TrackPlayer from 'react-native-track-player'

import { playbackService } from '@/constants/playbackService'
import { useLogTrackPlayerState } from '@/hooks/useLogTrackPlayerState'
import { useSetupTrackPlayer } from '@/hooks/useSetupTrackPlayer'
import ApolloClientProvider from '@/providers/ApolloClientProvider'
import { AuthProvider } from '@/providers/AuthProvider'

export { ErrorBoundary } from 'expo-router'

SplashScreen.preventAutoHideAsync()

TrackPlayer.registerPlaybackService(() => playbackService)

const App = () => {
	const [fontsLoaded, fontsError] = useFonts({
		SpaceMono: require('@/assets/fonts/SpaceMono-Regular.ttf'),
		...FontAwesome.font,
	})

	const handleTrackPlayerLoaded = useCallback(() => {
		SplashScreen.hideAsync()
	}, [])

	useSetupTrackPlayer({
		onLoad: handleTrackPlayerLoaded,
	})

	useLogTrackPlayerState()

	useEffect(() => {
		if (fontsError) throw fontsError
		if (fontsLoaded) SplashScreen.hideAsync()
	}, [fontsLoaded, fontsError])

	if (!fontsLoaded) {
		return null
	}

	return (
		<SafeAreaProvider>
			<GestureHandlerRootView style={{ flex: 1 }}>
				<RootLayoutNav />

				<StatusBar barStyle="dark-content" />
			</GestureHandlerRootView>
		</SafeAreaProvider>
	)
}

function RootLayoutNav() {
	const colorScheme = useColorScheme()

	return (
		<ThemeProvider value={colorScheme === 'dark' ? DarkTheme : DefaultTheme}>
			<ApolloClientProvider>
				<AuthProvider>
					{/* This is not working properly */}
					{/* <PreloadQueries /> */}
					<Stack>
						<Stack.Screen name="(auth)" options={{ headerShown: false }} />
						<Stack.Screen name="(tabs)" options={{ headerShown: false }} />
						<Stack.Screen
							name="player"
							options={{
								presentation: 'card',
								gestureEnabled: true,
								gestureDirection: 'vertical',
								animationDuration: 400,
								headerShown: false,
							}}
						/>
						<Stack.Screen
							name="(modals)/addToPlaylist"
							options={{
								presentation: 'modal',
								headerStyle: {
									backgroundColor: colors.background,
								},
								headerTitle: 'Add to playlist',
								headerTitleStyle: {
									color: colors.text,
								},
							}}
						/>
					</Stack>
				</AuthProvider>
			</ApolloClientProvider>
		</ThemeProvider>
	)
}

export default App
