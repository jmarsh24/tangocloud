import { FloatingPlayer } from '@/components/FloatingPlayer'
import { colors, fontSize } from '@/constants/tokens'
import { CURRENT_USER } from '@/graphql'
import { useAuth } from '@/providers/AuthProvider'
import { useQuery } from '@apollo/client'
import MaterialIcons from '@expo/vector-icons/MaterialIcons'
import { BlurView } from 'expo-blur'
import { Redirect, Tabs } from 'expo-router'
import { Image, Platform, StyleSheet, View } from 'react-native'

const TabsNavigation = () => {
	const { authState, onLogout } = useAuth()

	const { data, loading, error } = useQuery(CURRENT_USER, {
		skip: !authState.authenticated,
	})

	if (!authState.authenticated) {
		return <Redirect href="/" />
	}

	if (loading) {
		return null
	}

	if (error) {
		console.error('Error fetching user:', error)
	}

	const avatarUrl = data?.currentUser?.userPreference.avatar.blob.url

	const youIcon = (color) => {
		if (authState?.authenticated && avatarUrl) {
			return (
				<Image source={{ uri: avatarUrl }} style={{ width: 24, height: 24, borderRadius: 12 }} />
			)
		} else {
			return <MaterialIcons name="person" color={color} size={24} />
		}
	}

	const floatingPlayerHeight = Platform.OS === 'ios' ? 78 : 50

	return (
		<>
			<Tabs
				initialRouteName="home"
				screenOptions={{
					tabBarActiveTintColor: colors.text,
					tabBarLabelStyle: {
						fontSize: fontSize.xs,
						fontWeight: '500',
					},
					headerShown: false,
					tabBarStyle: {
						position: 'absolute',
						borderTopWidth: 0,
						paddingTop: 8,
					},
					tabBarBackground: () =>
						Platform.OS === 'ios' ? (
							<BlurView tint="dark" intensity={95} style={StyleSheet.absoluteFillObject} />
						) : (
							<View
								style={{ ...StyleSheet.absoluteFillObject, backgroundColor: '#252525', zIndex: -1 }}
							/>
						),
				}}
			>
				<Tabs.Screen
					name="(home)"
					options={{
						title: 'Home',
						headerShown: false,
						tabBarIcon: ({ color }) => <MaterialIcons name="home" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
					name="search"
					options={{
						title: 'Search',
						headerShown: false,
						tabBarIcon: ({ color }) => <MaterialIcons name="search" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
					name="favorites"
					options={{
						title: 'Favorites',
						headerShown: false,
						tabBarIcon: ({ color }) => <MaterialIcons name="favorite" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
 					name="you"
 					options={{
 						title: 'Your Profile',
 						headerShown: false,
 						tabBarIcon: ({ color }) => youIcon(color),
 					}}
 				/>
			</Tabs>
			<FloatingPlayer
				style={{
					position: 'absolute',
					bottom: floatingPlayerHeight,
					left: 8,
					right: 8,
				}}
			/>
		</>
	)
}

export default TabsNavigation
