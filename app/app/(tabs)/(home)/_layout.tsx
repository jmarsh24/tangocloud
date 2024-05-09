import { StackScreenWithSearchBar } from '@/constants/layout'
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
						...StackScreenWithSearchBar,
					}}
				/>
				<Stack.Screen
					name="playlists"
					options={{
						title: 'Playlists',
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}

export default HomeScreenLayout
