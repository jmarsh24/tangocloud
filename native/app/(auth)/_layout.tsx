import { useAuth } from '@/providers/AuthProvider'
import { defaultStyles } from '@/styles'
import { Redirect, Stack } from 'expo-router'
import { View } from 'react-native'
import { StackScreenWithSearchBar } from '@/constants/layout'

export default function AuthLayout() {
	const { authState } = useAuth()

	if (authState?.authenticated === true) {
		return <Redirect href={'/(root)/(tabs)/(home)/'} />
	}

	return (
		<View style={defaultStyles.container}>
			<Stack>
				<Stack.Screen
					name="index"
					options={{
						headerTitle: '',
						headerShown: false,
					}}
				/>
				<Stack.Screen
					name="login"
					options={{
						animation: 'none',
						headerTitle: '',
						...StackScreenWithSearchBar,
					}}
				/>
				<Stack.Screen
					name="register"
					options={{
						animation: 'none',
						headerTitle: '',
						...StackScreenWithSearchBar,
					}}
				/>
			</Stack>
		</View>
	)
}
