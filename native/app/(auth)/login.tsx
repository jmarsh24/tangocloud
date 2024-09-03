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
	TouchableWithoutFeedback,
	View,
} from 'react-native'
import { useAuth } from '@/providers/AuthProvider'
import { colors } from '@/constants/tokens'
import Button from '@/components/Button'

const LoginScreen = () => {
	const [login, setLogin] = useState('')
	const [password, setPassword] = useState('')
	const [loading, setLoading] = useState(false)
	const { onLogin } = useAuth()

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

	return (
		<View style={{ flex: 1 }}>
			<KeyboardAvoidingView
				style={{ flex: 1 }}
				behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
			>
				<View style={styles.container}>
					<TouchableWithoutFeedback onPress={Keyboard.dismiss}>
						<View style={styles.contentContainer}>
							<View style={styles.imageAndLogoContainer}>
								<Image source={require('@/assets/images/app_logo.png')} style={styles.image} />
								<Text style={styles.logo}>TangoCloud</Text>
							</View>

							<View style={styles.inputContainer}>
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
								<Button
									onPress={signIn}
									disabled={loading}
									text={loading ? 'Signing in...' : 'Sign in'}
									style={styles.button}
								/>
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
		flex: 1,
		padding: 20,
		justifyContent: 'space-between',
		paddingBottom: 40,
	},
	contentContainer: {
		flex: 1,
		justifyContent: 'flex-end',
		paddingBottom: 50,
	},
	imageAndLogoContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
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
	inputContainer: {
		width: '100%',
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
		marginTop: 5,
		marginBottom: 20,
	},
	icon: {
		position: 'absolute',
		left: 16,
		width: 24,
		height: 24,
	},
})

export default LoginScreen
