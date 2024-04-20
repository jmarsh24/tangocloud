import { FloatingPlayer } from '@/components/FloatingPlayer'
import { colors, fontSize } from '@/constants/tokens'
import { USER_PROFILE } from '@/graphql'
import { useAuth } from '@/providers/AuthProvider'
import { useQuery } from '@apollo/client'
import MaterialIcons from '@expo/vector-icons/MaterialIcons'
import { BlurView } from 'expo-blur'
import { Redirect, Tabs } from 'expo-router'
import { Image, StyleSheet } from 'react-native'

const TabsNavigation = () => {
	const { authState } = useAuth()

	if (!authState.authenticated) {
		return <Redirect href="/login" />
	}

	const { data, loading, error } = useQuery(USER_PROFILE, {
		skip: !authState.authenticated,
	})

	if (loading) {
		return null
	}

	if (error) {
		console.error('Error fetching user:', error)
	}

	const avatarUrl = data?.userProfile?.avatarUrl

	const youIcon = (color) => {
		if (authState?.authenticated && avatarUrl) {
			return (
				<Image source={{ uri: avatarUrl }} style={{ width: 24, height: 24, borderRadius: 12 }} />
			)
		} else {
			return <MaterialIcons name="person" color={color} size={24} />
		}
	}

	return (
		<>
			<Tabs
				screenOptions={{
					tabBarActiveTintColor: colors.primary,
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
					tabBarBackground: () => (
						<BlurView
							intensity={95}
							style={{
								...StyleSheet.absoluteFillObject,
							}}
						/>
					),
				}}
			>
				<Tabs.Screen
					name="playlists"
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
				<Tabs.Screen
					name="(home)"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
				<Tabs.Screen
					name="orchestras"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
				<Tabs.Screen
					name="lyricists"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
				<Tabs.Screen
					name="composers"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
				<Tabs.Screen
					name="singers"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
				<Tabs.Screen
					name="library"
					options={{
						href: null,
						headerShown: false,
					}}
				/>
			</Tabs>

			<FloatingPlayer
				style={{
					position: 'absolute',
					bottom: 78,
					left: 8,
					right: 8,
				}}
			/>
		</>
	)
}

export default TabsNavigation
