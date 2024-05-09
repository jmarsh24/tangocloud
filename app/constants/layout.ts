import { colors } from '@/constants/tokens'
import { NativeStackNavigationOptions } from '@react-navigation/native-stack'
import { Platform } from 'react-native'

export const StackScreenWithSearchBar: NativeStackNavigationOptions = {
	headerLargeTitle: true,
	headerLargeStyle: {
		backgroundColor: colors.background,
	},
	headerLargeTitleStyle: {
		color: colors.text,
	},
	headerTintColor: colors.text,
	headerBlurEffect: 'prominent',
	headerShadowVisible: false,
	...(Platform.OS === 'ios' && {
		headerTransparent: true,
	}),
}
