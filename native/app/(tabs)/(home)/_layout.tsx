import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

const HomeScreenLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						title: 'Home',
						headerShown: false,
					}}
				/>
				<Stack.Screen
					name="playlists"
					options={{
						headerShown: false,
					}}
				/>
				<Stack.Screen
					name="orchestras"
					options={{
						headerShown: false,
					}}
				/>
			</Stack>
		</View>
	)
}

export default HomeScreenLayout
