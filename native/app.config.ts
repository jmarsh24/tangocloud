import { ExpoConfig } from 'expo/config'

const bundleIdentifier = process.env.BUNDLE_IDENTIFIER ?? 'com.tangocloud.app';

export default (): ExpoConfig => {
	return {
		name: 'Tango Cloud',
		slug: 'app',
		version: '1.0.38',
		owner: 'tangocloud',
		orientation: 'portrait',
		icon: './assets/icon.png',
		userInterfaceStyle: 'dark',
		scheme: 'tangocloudapp',
		splash: {
			image: './assets/splash.png',
			resizeMode: 'contain',
			backgroundColor: '#000000',
		},
		assetBundlePatterns: ['**/*'],
		ios: {
			supportsTablet: true,
			bundleIdentifier,
			runtimeVersion: '1.0.0',
			buildNumber: '70',
			usesAppleSignIn: true,
			config: {
				usesNonExemptEncryption: false,
			},
			infoPlist: {
				UIBackgroundModes: ['audio'],
				NSMicrophoneUsageDescription: 'This app needs access to the speaker for streaming music.',
				ITSAppUsesNonExemptEncryption: false,
				CFBundleURLTypes: [
					{
						CFBundleURLSchemes: [
							'com.googleusercontent.apps.863366754084-tqj96bqgkgda0lsq5u4jrmpt53lkkqs9',
						],
					},
				],
			},
			associatedDomains: ['applinks:tangocloud.app'],
		},
		android: {
			package: 'com.tangocloud.app',
			versionCode: 39,
			runtimeVersion: {
				policy: 'appVersion',
			},
			adaptiveIcon: {
				foregroundImage: './assets/adaptive-icon.png',
				backgroundColor: '#000000',
			},
			intentFilters: [
				{
					action: 'VIEW',
					data: {
						scheme: 'tangocloudapp',
						host: 'recordings',
						pathPrefix: '/',
					},
					category: ['BROWSABLE', 'DEFAULT'],
				},
			],
		},
		plugins: [
			'expo-router',
			[
				'expo-secure-store',
				{
					faceIDPermission: 'Allow $(PRODUCT_NAME) to access your Face ID biometric data.',
				},
			],
			'expo-font',
			'expo-apple-authentication',
			[
				'react-native-fbsdk-next',
				{
					appID: '325815450571709',
					clientToken: '53239ed566763bd1a5492063838c2da7',
					displayName: 'TangoCloud',
					scheme: 'fb325815450571709',
					advertiserIDCollectionEnabled: false,
					autoLogAppEventsEnabled: false,
					isAutoInitEnabled: true,
					iosUserTrackingPermission:
						'This identifier will be used to deliver personalized ads to you.',
				},
			],
			[
				'@react-native-google-signin/google-signin',
				{
					iosUrlScheme: 'com.googleusercontent.apps.863366754084-tqj96bqgkgda0lsq5u4jrmpt53lkkqs9',
				},
			],
		],
		experiments: {
			typedRoutes: true,
			tsconfigPaths: true,
		},
		extra: {
			eas: {
				projectId: '40b28cff-7ae4-44c3-b2b4-da1eb1d5081b',
			},
			currentVersion: '1.0.38',
		},
		updates: {
			url: 'https://u.expo.dev/40b28cff-7ae4-44c3-b2b4-da1eb1d5081b',
		},
	}
}
