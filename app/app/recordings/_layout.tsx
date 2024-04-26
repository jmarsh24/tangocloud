import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

export const TracksLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen name="[id]" />
			</Stack>
		</View>
	)
}

export default TracksLayout
