import { createContext, useContext, useEffect, useState, PropsWithChildren } from 'react'
import { useApolloClient, ApolloError } from '@apollo/client'
import { REGISTER, LOGIN, APPLE_LOGIN, GOOGLE_LOGIN, REFRESH } from '@/graphql'
import * as SecureStore from 'expo-secure-store'
import * as AppleAuthentication from 'expo-apple-authentication'
import { GoogleSignin } from '@react-native-google-signin/google-signin'

interface AuthState {
	token: string | null
	refreshToken: string | null
	authenticated: boolean | null
}

interface AuthContextType {
	authState: AuthState
	onRegister: (username: string, email: string, password: string) => Promise<any>
	onLogin: (login: string, password: string) => Promise<any>
	onAppleLogin: () => Promise<any>
	onGoogleLogin: () => Promise<any>
	onLogout: () => Promise<void>
	refreshToken: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export const AuthProvider = ({ children }: PropsWithChildren) => {
	const apolloClient = useApolloClient()
	const [authState, setAuthState] = useState<AuthState>({
		token: null,
		refreshToken: null,
		authenticated: null,
	})

	useEffect(() => {
		const loadToken = async () => {
			const token = await SecureStore.getItemAsync('token')
			const refreshToken = await SecureStore.getItemAsync('refreshToken')
			if (token) {
				setAuthState({
					token: token,
					refreshToken: refreshToken,
					authenticated: true,
				})
			}
		}
		loadToken()
	}, [])

	const refreshToken = async () => {
		if (!authState.refreshToken) return

		try {
			const { data } = await apolloClient.mutate({
				mutation: REFRESH,
				variables: { refreshToken: authState.refreshToken },
			})

			if (data.refresh.access) {
				setAuthState({
					token: data.refresh.access,
					refreshToken: data.refresh.refresh,
					authenticated: true,
				})
				await SecureStore.setItemAsync('token', data.refresh.access)
				await SecureStore.setItemAsync('refreshToken', data.refresh.refresh)
			} else {
				await logout()
			}
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

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
				token: data.login.session.access,
				refreshToken: data.login.session.refresh,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.login.session.access)
			await SecureStore.setItemAsync('refreshToken', data.login.session.refresh)
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
				token: data.appleLogin.session.access,
				refreshToken: data.appleLogin.session.refresh,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.appleLogin.session.access)
			await SecureStore.setItemAsync('refreshToken', data.appleLogin.session.refresh)
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
				token: data.googleLogin.session.access,
				refreshToken: data.googleLogin.session.refresh,
				authenticated: true,
			})

			await SecureStore.setItemAsync('token', data.googleLogin.session.access)
			await SecureStore.setItemAsync('refreshToken', data.googleLogin.session.refresh)
			return data.googleLogin
		} catch (error) {
			const apolloError = error as ApolloError
			throw new Error(apolloError.message)
		}
	}

	const logout = async () => {
		await SecureStore.deleteItemAsync('token')
		await SecureStore.deleteItemAsync('refreshToken')
		setAuthState({
			token: null,
			refreshToken: null,
			authenticated: false,
		})
	}

	const value = {
		authState,
		onRegister: register,
		onLogin: login,
		onAppleLogin: appleLogin,
		onGoogleLogin: googleLogin,
		onLogout: logout,
		refreshToken: refreshToken,
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
