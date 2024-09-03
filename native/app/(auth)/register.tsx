import React, { useState } from 'react'
import {
	Alert,
	Image,
	KeyboardAvoidingView,
	Platform,
	StyleSheet,
	Text,
	TextInput,
	View,
} from 'react-native'
import { useAuth } from '@/providers/AuthProvider'
import { colors } from '@/constants/tokens'
import Button from '@/components/Button'

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
		} finally {
			setLoading(false)
		}
	}

	return (
		<View style={styles.fullScreen}>
			<KeyboardAvoidingView
				style={styles.fullScreen}
				behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
			>
				<View style={styles.container}>
					<View style={styles.imageAndLogoContainer}>
						<Image source={require('@/assets/images/app_logo.png')} style={styles.image} />
						<Text style={styles.logo}>TangoCloud</Text>
					</View>

					<View style={styles.formContainer}>
						<View style={styles.formGroup}>
							<View style={styles.inputGroup}>
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
							<View style={styles.buttonContainer}>
								<Button
									onPress={register}
									disabled={loading}
									text={loading ? 'Creating account...' : 'Create account'}
									style={styles.button}
								/>
							</View>
						</View>
					</View>
				</View>
			</KeyboardAvoidingView>
		</View>
	)
}

const styles = StyleSheet.create({
	fullScreen: {
		flex: 1,
	},
	container: {
		flex: 1,
		padding: 20,
	},
	imageAndLogoContainer: {
		flex: 1,
		alignItems: 'center',
		justifyContent: 'center',

	},
	image: {
		width: 200,
		height: 200,
		resizeMode: 'contain',
	},
	logo: {
		fontSize: 48,
		fontWeight: 'bold',
		color: colors.text,
		textAlign: 'center',
	},
	formContainer: {
		paddingBottom: 50,
	},
	formGroup: {
		gap: 24,
	},
	inputGroup: {
		gap: 8,
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
	buttonContainer: {
		gap: 10,
	},
	button: {
		width: '100%',
		height: 36,
		paddingVertical: 8,
	},
})

export default RegisterScreen
