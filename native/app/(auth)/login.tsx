import React, { useState } from 'react'
import {
	Alert,
	Image,
	Keyboard,
	KeyboardAvoidingView,
	Platform,
	StyleSheet,
	Text,
	TextInput,
	TouchableOpacity,
	TouchableWithoutFeedback,
	View,
} from 'react-native'
import { useAuth } from '@/providers/AuthProvider'
import { Link } from 'expo-router'
import { colors } from '@/constants/tokens'
import Button from '@/components/Button'
import * as AppleAuthentication from 'expo-apple-authentication'
import { AntDesign } from '@expo/vector-icons' // You can use other icons if you prefer

const LoginScreen = () => {
	const [login, setLogin] = useState('')
	const [password, setPassword] = useState('')
	const [loading, setLoading] = useState(false)
	const { onLogin, onAppleLogin, onGoogleLogin } = useAuth()

	async function signIn() {
		setLoading(true)
		try {
			await onLogin(login, password)
		} catch (error) {
			Alert.alert('Login Failed', error.message)
		} finally {
			setLoading(false)
		}
	}

	async function signInWithApple() {
		setLoading(true)
		try {
			await onAppleLogin()
		} finally {
			setLoading(false)
		}
	}

	async function signInWithGoogle() {
		setLoading(true)
		try {
			await onGoogleLogin()
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
						<View style={styles.container}>
							<View>
								<Text style={styles.label}>Email or Username</Text>
								<TextInput
									value={login}
									onChangeText={setLogin}
									placeholder="ElSeniorDeTango"
									autoCorrect={false}
									autoComplete="username"
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
								<View style={styles.buttonContainer}>
									<Button
										onPress={signIn}
										disabled={loading}
										text={loading ? 'Signing in...' : 'Sign in'}
										style={styles.button}
									/>
								</View>
							</View>
						</View>
					</TouchableWithoutFeedback>
				</View>
			</KeyboardAvoidingView>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		padding: 20,
		flex: 1,
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
		marginTop: 5,
		marginBottom: 20,
		backgroundColor: colors.background,
		borderRadius: 5,
		fontSize: 18,
		color: colors.text,
	},
	textButton: {
		alignSelf: 'center',
		fontWeight: 'bold',
		color: colors.text,
		marginVertical: 10,
	},
	image: {
		width: 200,
		height: 200,
	},
	imageContainer: {
		width: '100%',
		alignItems: 'center',
	},
	button: {
		width: '100%',
		height: 36,
		paddingVertical: 8,
	},
	buttonContainer: {
		gap: 10,
	},
	customButton: {
		flexDirection: 'row',
		alignItems: 'center',
		justifyContent: 'center',
		width: '100%',
		height: 40,
		borderColor: 'white',
		borderRadius: 5,
		borderWidth: 1,
	},
	icon: {
		position: 'absolute',
		left: 16,
		width: 24,
		height: 24,
	},
	buttonText: {
		fontSize: 16,
		color: 'white',
	},
})

export default LoginScreen
