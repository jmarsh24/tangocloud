import { FloatingPlayer } from '@/components/FloatingPlayer'
import { colors, fontSize } from '@/constants/tokens'

import MaterialIcons from '@expo/vector-icons/MaterialIcons'
import Ionicons from '@expo/vector-icons/Ionicons'
import { BlurView } from 'expo-blur'
import { Tabs } from 'expo-router'
import { Platform, StyleSheet, View } from 'react-native'

const TabsNavigation = () => {
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
					name="radio"
					options={{
						title: 'Radio',
						headerShown: false,
						tabBarIcon: ({ color }) => <MaterialIcons name="radio" size={24} color={color} />,
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
					name="collection"
					options={{
						title: 'Collection',
						headerShown: false,
						tabBarIcon: ({ color }) => <Ionicons name="albums" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
 					name="profile"
 					options={{
 						title: 'Your Profile',
 						headerShown: false,
						href: null
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
