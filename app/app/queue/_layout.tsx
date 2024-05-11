import { defaultStyles } from '@/styles'
import { Stack } from 'expo-router'
import { View } from 'react-native'
import { MaterialIcons } from '@expo/vector-icons'
import { Pressable } from 'react-native'
import { useNavigation } from 'expo-router'

export const QueueLayout = () => {
	const navigation = useNavigation()
	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						presentation: 'card',
						headerTitle: '',
						headerStyle: { backgroundColor: 'black' },
						headerLeft:() => 
								<Pressable onPress={() => navigation.goBack()}>
									<MaterialIcons name="close" size={36} color="white" />
								</Pressable>
					}}
				/>
			</Stack>
		</View>
	)
}

export default QueueLayout
