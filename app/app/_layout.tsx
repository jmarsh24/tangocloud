import { colors } from '@/constants/tokens'
import FontAwesome from '@expo/vector-icons/FontAwesome'
import { DarkTheme, ThemeProvider } from '@react-navigation/native'
import { useFonts } from 'expo-font'
import { SplashScreen, Stack } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { useCallback, useEffect } from 'react'
import { GestureHandlerRootView } from 'react-native-gesture-handler'
import { SafeAreaProvider } from 'react-native-safe-area-context'
import TrackPlayer from 'react-native-track-player'

import { playbackService } from '@/constants/playbackService'
import { useLogTrackPlayerState } from '@/hooks/useLogTrackPlayerState'
import { useSetupTrackPlayer } from '@/hooks/useSetupTrackPlayer'
import { updateIfPossible } from '@/model/updates'
import ApolloClientProvider from '@/providers/ApolloClientProvider'
import { AuthProvider } from '@/providers/AuthProvider'

export { ErrorBoundary } from 'expo-router'

SplashScreen.preventAutoHideAsync()

TrackPlayer.registerPlaybackService(() => playbackService)

async function startup(): Promise<void> {
	await updateIfPossible()
}

const App = () => {
	const [fontsLoaded] = useFonts({
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
		startup()
	})

	useEffect(() => {
		if (fontsLoaded) {
			SplashScreen.hideAsync()
		}
	}, [fontsLoaded])

	if (!fontsLoaded) {
		return null
	}

	return (
		<SafeAreaProvider>
			<GestureHandlerRootView style={{ flex: 1 }}>
				<RootLayoutNav />

				<StatusBar style="light" />
			</GestureHandlerRootView>
		</SafeAreaProvider>
	)
}

function RootLayoutNav() {
	return (
		<ThemeProvider value={DarkTheme}>
			<ApolloClientProvider>
				<AuthProvider>
					<Stack>
						<Stack.Screen name="(auth)" options={{ headerShown: false }} />
						<Stack.Screen name="(tabs)" options={{ headerShown: false }} />
						<Stack.Screen name="recordings" options={{ headerShown: false }} />
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
