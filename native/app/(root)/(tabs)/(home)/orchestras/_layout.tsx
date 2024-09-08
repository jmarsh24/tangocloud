import { StackScreenWithSearchBar } from '@/constants/layout'
import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

const OrchestrasLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						title: 'Orchestras',
						...StackScreenWithSearchBar,
					}}
				/>
				<Stack.Screen
					name="[id]"
					options={{
						title: 'Orchestra',
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}

export default OrchestrasLayout
