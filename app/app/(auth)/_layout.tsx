import { StackScreenWithSearchBar } from '@/constants/layout'
import { useAuth } from '@/providers/AuthProvider'
import { defaultStyles } from '@/styles'
import { Redirect, Stack } from 'expo-router'
import { View } from 'react-native'

export default function AuthLayout() {
	const { authState } = useAuth()

	if (authState?.authenticated === true) {
		return <Redirect href={'/'} />
	}

	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="login"
					options={{
						headerShown: false,
						animation: 'none',
						...StackScreenWithSearchBar,
					}}
				/>
				<Stack.Screen
					name="register"
					options={{
						headerShown: false,
						animation: 'none',
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}
