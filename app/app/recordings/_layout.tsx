import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'

export const RecordingsLayout = () => {
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen 
					name="[id]"
					options={{
            headerShown: false
          }} 
				/>
			</Stack>
		</View>
	)
}

export default RecordingsLayout
