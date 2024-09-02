import React, { useState } from 'react'
import { Image, Platform, StyleSheet, Text, TouchableOpacity, View } from 'react-native'
import { useAuth } from '@/providers/AuthProvider'
import { Link } from 'expo-router'
import { colors } from '@/constants/tokens'
import { AntDesign } from '@expo/vector-icons'

const LoginScreen = () => {
	const [loading, setLoading] = useState(false)
	const { onAppleLogin, onGoogleLogin } = useAuth()

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
			<View style={styles.container}>
				<View style={styles.contentContainer}>
					<View style={styles.imageAndLogoContainer}>
						<Image source={require('@/assets/images/app_logo.png')} style={styles.image} />
						<Text style={styles.logo}>TangoCloud</Text>
					</View>
				</View>

				<View style={styles.buttonContainer}>
					<TouchableOpacity style={styles.linkButton}>
						<Link
							href="/register"
							style={styles.linkButtonText}
						>
							Sign Up Free
						</Link>
					</TouchableOpacity>

					{Platform.OS === 'ios' && (
						<TouchableOpacity
							onPress={signInWithApple}
							style={[styles.customButton, { backgroundColor: 'black' }]}
							disabled={loading}
						>
							<AntDesign name="apple1" size={24} color="white" style={styles.icon} />
							<Text style={styles.buttonText}>Continue with Apple</Text>
						</TouchableOpacity>
					)}

					<TouchableOpacity
						onPress={signInWithGoogle}
						style={[styles.customButton, { backgroundColor: 'black' }]}
						disabled={loading}
					>
						<Image source={require('@/assets/images/google_logo.png')} style={styles.icon} />
						<Text style={[styles.buttonText, { color: colors.text }]}>Continue with Google</Text>
					</TouchableOpacity>

					<Link href="/login" style={styles.textButton}>
						Log in
					</Link>
				</View>
			</View>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'space-between',
		padding: 20,
		paddingBottom: 40,
	},
	contentContainer: {
		flex: 1,
		justifyContent: 'center',
		alignItems: 'center',
	},
	imageAndLogoContainer: {
		alignItems: 'center',
	},
	image: {
		width: 250,
		height: 250,
    resizeMode: 'contain'
	},
	linkButtonText: {
		color: 'white',
		fontWeight: '600',
		width: '100%',
		height: '100%',
		textAlign: 'center',
	},
	linkButton: {
		width: '100%',
		height: 36,
		paddingVertical: 8,
		color: 'white',
		fontWeight: 'bold',
		justifyContent: 'center',
		alignItems: 'center',
		backgroundColor: colors.primary,
		textAlign: 'center',
		borderRadius: 5,
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
		borderColor: 'rgba(255, 255, 255, 0.3)',
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
	logo: {
		fontSize: 48,
		fontWeight: 'bold',
		color: colors.text,
		textAlign: 'center',
	},
	textButton: {
		alignSelf: 'center',
		fontWeight: 'bold',
		color: colors.text,
		marginVertical: 10,
	},
})

export default LoginScreen
