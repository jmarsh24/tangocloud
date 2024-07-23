import { createContext, useContext, useEffect, useState, PropsWithChildren } from 'react'
import { useApolloClient, ApolloError } from '@apollo/client'
import { REGISTER, LOGIN, APPLE_LOGIN, GOOGLE_LOGIN, FACEBOOK_LOGIN } from '@/graphql'
import * as SecureStore from 'expo-secure-store'
import * as AppleAuthentication from 'expo-apple-authentication'
import { GoogleSignin } from '@react-native-google-signin/google-signin'
import { AccessToken, LoginManager } from 'react-native-fbsdk-next'

interface AuthState {
	token: string | null
	authenticated: boolean | null
}

interface AuthContextType {
	authState: AuthState
	onRegister: (username: string, email: string, password: string) => Promise<any>
	onLogin: (login: string, password: string) => Promise<any>
	onAppleLogin: () => Promise<any>
	onGoogleLogin: () => Promise<any>
	onLogout: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export const AuthProvider = ({ children }: PropsWithChildren) => {
	const apolloClient = useApolloClient()
	const [authState, setAuthState] = useState<AuthState>({
		token: null,
		authenticated: null,
	})

	useEffect(() => {
		const loadToken = async () => {
			const token = await SecureStore.getItemAsync('token')

			if (token) {
				setAuthState({
					token: token,
					authenticated: true,
				})
			}
		}
		loadToken()
	}, [])

	const register = async (username: string, email: string, password: string) => {
		try {
			const { data } = await apolloClient.mutate({
				mutation: REGISTER,
				variables: { username, email, password },
			})

			return data.register
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const login = async (login: string, password: string) => {
		try {
			const { data } = await apolloClient.mutate({
				mutation: LOGIN,
				variables: { login, password },
			})
			setAuthState({
				token: data.login.token,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.login.token)
			return data.login
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const appleLogin = async () => {
		try {
			const credential = await AppleAuthentication.signInAsync({
				requestedScopes: [
					AppleAuthentication.AppleAuthenticationScope.FULL_NAME,
					AppleAuthentication.AppleAuthenticationScope.EMAIL,
				],
			})

			const { data } = await apolloClient.mutate({
				mutation: APPLE_LOGIN,
				variables: {
					userIdentifier: credential.user,
					identityToken: credential.identityToken,
					email: credential.email,
					firstName: credential.fullName?.givenName,
					lastName: credential.fullName?.familyName,
				},
			})

			setAuthState({
				token: data.appleLogin.token,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.appleLogin.token)
			return data.appleLogin
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const googleLogin = async () => {
		try {
			await GoogleSignin.hasPlayServices()
			const userInfo = await GoogleSignin.signIn()
			const { idToken } = userInfo

			const { data } = await apolloClient.mutate({
				mutation: GOOGLE_LOGIN,
				variables: { idToken: idToken },
			})

			setAuthState({
				token: data.googleLogin.token,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.googleLogin.token)
			return data.googleLogin
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const facebookLogin = async () => {
		try {
			// Attempt to get current access token
			let token = await AccessToken.getCurrentAccessToken()

			// If no token, prompt the user to log in
			if (!token) {
				const result = await LoginManager.logInWithPermissions(['public_profile', 'email'])
				if (result.isCancelled) {
					throw new Error('User cancelled the login process')
				}
				// Fetch new access token after successful login
				token = await AccessToken.getCurrentAccessToken()
			}

			if (!token) {
				throw new Error('Unable to obtain access token')
			}

			const { data } = await apolloClient.mutate({
				mutation: FACEBOOK_LOGIN,
				variables: { accessToken: token.accessToken },
			})

			setAuthState({
				token: data.facebookLogin.token,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.facebookLogin.token)
			return data.facebookLogin
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const logout = async () => {
		await SecureStore.deleteItemAsync('token')
		setAuthState({
			token: null,
			authenticated: false,
		})
	}

	const value = {
		authState,
		onRegister: register,
		onLogin: login,
		onAppleLogin: appleLogin,
		onGoogleLogin: googleLogin,
		onFacebookLogin: facebookLogin,
		onLogout: logout,
	}

	return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

export const useAuth = () => {
	const context = useContext(AuthContext)
	if (context === undefined) {
		throw new Error('useAuth must be used within an AuthProvider')
	}
	return context
}
