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
						title: 'Playlists',
						...StackScreenWithSearchBar,
					}}
				/>
				<Stack.Screen
					name="[id]"
					options={{
						title: 'Playlist',
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}

export default PlaylistsLayout
