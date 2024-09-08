import { StackScreenWithSearchBar } from '@/constants/layout'
import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

const RootLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen name="recordings" options={{ headerShown: false }} />
				<Stack.Screen name="player" options={{ headerShown: false, presentation: 'modal' }} />
				<Stack.Screen name="queue" options={{ headerShown: false, animation: 'fade' }} />
				<Stack.Screen name="lyrics" options={{ headerShown: false, animation: 'fade' }} />
			</Stack>
		</View>
	)
}

export default RootLayout
