import { checkForUpdateAsync, fetchUpdateAsync, reloadAsync } from 'expo-updates'
import Constants from 'expo-constants'

export async function updateIfPossible(): Promise<void> {
	if (__DEV__) return
	try {
		const update = await checkForUpdateAsync()
		if (update.isAvailable) {
			// eslint-disable-next-line no-console
			console.log('new update is available', update)
			try {
				await fetchUpdateAsync()
			} finally {
				// https://github.com/expo/expo/issues/14359 the fetch call throws even though it succeeds on ios, reload anyway
				await reloadAsync()
			}
		}
	} catch (error) {
		// eslint-disable-next-line no-console
		console.log(error)
	}
}

export const currentVersion: string = Constants.expoConfig?.extra?.currentVersion
