import { Stack } from 'expo-router'
import { defaultStyles } from '@/styles'
import { View } from 'react-native'
import { StackScreenWithSearchBar } from '@/constants/layout'

const HomeScreenLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen name="index" options={{ title: 'Home', headerShown: false }} />
			</Stack>
		</View>
	)
}

export default HomeScreenLayout
