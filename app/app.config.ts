import { ExpoConfig } from 'expo/config';

const apiUrl = process.env.API_URL || 'https://tangocloud.app/graphql';
const currentVersion =
  (process.env.EAS_BUILD_GIT_COMMIT_HASH || '').slice(0, 8) || '00000000';
const bundleIdentifier = process.env.BUNDLE_IDENTIFIER ?? 'tangocloud.app';
const icon = './assets/icon.png';

export default (): ExpoConfig => {
  return {
    name: 'tangocloud',
    owner: 'jmarsh24',
    slug: 'tangocloud',
    platforms: ['ios'],
    version: '1.0.0',
    orientation: 'portrait',
    icon,
    userInterfaceStyle: 'light',
    scheme: 'laic',
    splash: {
      image: './assets/splash.png',
      resizeMode: 'contain',
      backgroundColor: '#ffffff',
    },
    assetBundlePatterns: ['**/*'],
    ios: {
      supportsTablet: false,
      bundleIdentifier,
      config: {
        usesNonExemptEncryption: false,
      },
    },
    android: {
      adaptiveIcon: {
        foregroundImage: './assets/adaptive-icon.png',
        backgroundColor: '#FFFFFF',
      },
    },
    web: {
      favicon: './assets/favicon.png',
    },
    runtimeVersion: {
      policy: 'sdkVersion',
    },
    extra: {
      apiUrl,
      loginProxy,
      currentVersion,
    },
    plugins: ['expo-router'],
  };
};
