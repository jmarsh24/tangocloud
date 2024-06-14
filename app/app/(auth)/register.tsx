import Button from '@/components/Button'
import { colors } from '@/constants/tokens'
import { useAuth } from '@/providers/AuthProvider'
import { Link } from 'expo-router'
import { useState } from 'react'
import {
	Alert,
	Image,
	Keyboard,
	KeyboardAvoidingView,
	Platform,
	ScrollView,
	StyleSheet,
	Text,
	TextInput,
	TouchableWithoutFeedback,
	View,
} from 'react-native'

const RegisterScreen = () => {
	const { onRegister } = useAuth()
	const [username, setUsername] = useState('')
	const [email, setEmail] = useState('')
	const [password, setPassword] = useState('')
	const [loading, setLoading] = useState(false)

	async function register() {
		setLoading(true)
		try {
			const result = await onRegister(username, email, password)
			if (result.success) {
				Alert.alert(
					'Verification Required',
					'Please check your email to verify your account before signing in.',
					[{ text: 'OK', onPress: () => router.replace('/login') }],
				)
			} else {
				const errorMessages = result.errors?.fullMessages?.join('\n') || 'Please try again later.'
				Alert.alert('Registration Failed', errorMessages)
			}
		} catch (error) {
			Alert.alert(
				'Registration Failed',
				error.message || 'An unexpected error occurred. Please try again.',
			)
		} finally {
			setLoading(false)
		}
	}

	return (
		<View style={{ flex: 1 }}>
			<KeyboardAvoidingView
				style={{ flex: 1 }}
				behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
			>
				<View style={{ flex: 1 }}>
					<TouchableWithoutFeedback onPress={Keyboard.dismiss}>
						<View style={{ flex: 1 }}>
							<ScrollView
								style={styles.container}
								contentContainerStyle={styles.scrollContainer}
								showsVerticalScrollIndicator={false}
							>
								<View style={{ flex: 1, justifyContent: 'center', paddingBottom: 50 }}>
									<View style={styles.imageContainer}>
										<Image source={require('@/assets/icon.png')} style={styles.image} />
									</View>
									<View style={{ gap: 24 }}>
										<View style={{ gap: 8 }}>
											<Text style={styles.label}>Username</Text>
											<TextInput
												value={username}
												onChangeText={setUsername}
												placeholder="ElSeniorDeTango"
												autoCorrect={false}
												autoComplete="username"
												autoCapitalize="none"
												textContentType="username"
												style={styles.input}
											/>

											<Text style={styles.label}>Email</Text>
											<TextInput
												value={email}
												onChangeText={setEmail}
												placeholder="carlosdisarli@hotmail.com"
												autoCorrect={false}
												autoComplete="email"
												autoCapitalize="none"
												textContentType="emailAddress"
												keyboardType="email-address"
												style={styles.input}
											/>

											<Text style={styles.label}>Password</Text>
											<TextInput
												value={password}
												onChangeText={setPassword}
												placeholder=""
												style={styles.input}
												autoComplete="password"
												secureTextEntry
											/>
										</View>
										<View>
											<Button
												onPress={register}
												disabled={loading}
												text={loading ? 'Creating account...' : 'Create account'}
												style={styles.button}
											/>
											<Link replace href="/login" style={styles.textButton}>
												Sign in
											</Link>
										</View>
									</View>
								</View>
							</ScrollView>
						</View>
					</TouchableWithoutFeedback>
				</View>
			</KeyboardAvoidingView>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		padding: 20,
	},
	scrollContainer: {
		flexGrow: 1,
		justifyContent: 'center',
	},
	label: {
		color: colors.text,
	},
	input: {
		width: '100%',
		borderWidth: 1,
		borderColor: colors.icon,
		padding: 10,
		backgroundColor: colors.background,
		borderRadius: 5,
		fontSize: 18,
		color: colors.text,
	},
	textButton: {
		alignSelf: 'center',
		fontWeight: 'bold',
		color: colors.text,
		paddingVertical: 20,
	},
	imageContainer: {
		alignItems: 'center',
	},
	image: {
		width: 200,
		height: 200,
	},
	button: {
		width: '100%',
	},
})

export default RegisterScreen
