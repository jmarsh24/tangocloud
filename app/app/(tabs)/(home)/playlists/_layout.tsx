import { StackScreenWithSearchBar } from '@/constants/layout'
import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

const PlaylistsLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						...StackScreenWithSearchBar,
						headerTitle: 'Playlists',
					}}
				/>
				<Stack.Screen
					name="[id]"
					options={{
						headerShown: false,
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}

export default PlaylistsLayout
