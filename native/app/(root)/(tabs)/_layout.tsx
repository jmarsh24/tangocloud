import { FloatingPlayer } from '@/components/FloatingPlayer'
import { colors, fontSize } from '@/constants/tokens'
import { CURRENT_USER } from '@/graphql'
import { useAuth } from '@/providers/AuthProvider'
import { useQuery } from '@apollo/client'
import MaterialIcons from '@expo/vector-icons/MaterialIcons'
import { BlurView } from 'expo-blur'
import { Redirect, Tabs } from 'expo-router'
import { Platform, StyleSheet, View, Text } from 'react-native'
import { Ionicons } from '@expo/vector-icons'
import React from 'react'

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
						title: 'Radio',
						headerLeft: () => <View><Text>hello</Text></View>,
						tabBarIcon: ({ color }) => <MaterialIcons name="radio" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
					name="search"
					options={{
						title: 'Search',
						tabBarIcon: ({ color }) => <MaterialIcons name="search" size={24} color={color} />,
					}}
				/>
				<Tabs.Screen
					name="collection"
					options={{
						title: 'Collection',
						tabBarIcon: ({ color }) => <Ionicons name="albums" size={24} color={color} />,
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
