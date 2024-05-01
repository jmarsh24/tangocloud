import { ExpoConfig } from 'expo/config'

export default (): ExpoConfig => {
	return {
		name: 'Tango Cloud',
		slug: 'app',
		version: '1.0.24',
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
			bundleIdentifier: 'tangocloud',
			runtimeVersion: '1.0.0',
			buildNumber: '67',
			config: {
				usesNonExemptEncryption: false,
			},
			infoPlist: {
				UIBackgroundModes: ['audio'],
				NSMicrophoneUsageDescription: 'This app needs access to the speaker for streaming music.',
				ITSAppUsesNonExemptEncryption: false,
			},
			associatedDomains: ['applinks:tangocloud.app'],
		},
		android: {
			package: 'com.tangocloud.app',
			versionCode: 35,
			runtimeVersion: {
				policy: 'appVersion',
			},
			adaptiveIcon: {
				foregroundImage: './assets/adaptive-icon.png',
				backgroundColor: '#00000',
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
		],
		experiments: {
			typedRoutes: true,
			tsconfigPaths: true,
		},
		extra: {
			eas: {
				projectId: '40b28cff-7ae4-44c3-b2b4-da1eb1d5081b',
			},
			currentVersion: '1.0.24',
		},
		updates: {
			url: 'https://u.expo.dev/40b28cff-7ae4-44c3-b2b4-da1eb1d5081b',
		},
	}
}
