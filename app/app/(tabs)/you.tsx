import Button from '@/components/Button'
import { TracksListItem } from '@/components/TracksListItem'
import { USER_PROFILE } from '@/graphql'
import { useAuth } from '@/providers/AuthProvider'
import { utilsStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { FlashList } from '@shopify/flash-list'
import { Link } from 'expo-router'
import React from 'react'
import { ActivityIndicator, Image, StyleSheet, Text, View } from 'react-native'
import FastImage from 'react-native-fast-image'
import { SafeAreaView } from 'react-native-safe-area-context'
import TrackPlayer from 'react-native-track-player'

export default function YouScreen() {
	const { authState, onLogout } = useAuth()
	const { colors } = useTheme()

	const { data, loading, error } = useQuery(USER_PROFILE, {
		skip: !authState.authenticated,
	})

	const ItemDivider = () => (
		<View style={{ ...utilsStyles.itemSeparator, marginVertical: 9, marginLeft: 60 }} />
	)

	const handleTrackSelect = async (track) => {
		const queue = await TrackPlayer.getQueue()
		const trackIndex = queue.findIndex((qTrack) => qTrack.id === track.id)

		if (trackIndex === -1) {
			await TrackPlayer.add(track)
			await TrackPlayer.skipToNext()
		} else {
			await TrackPlayer.skip(trackIndex)
		}

		TrackPlayer.play()
	}

	if (!authState.authenticated) {
		return (
			<SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
				<Link href="/login" asChild>
					<Button onPress={onLogout} text="Login" />
				</Link>
				<Link href="/register" asChild>
					<Button onPress={onLogout} text="Register" />
				</Link>
			</SafeAreaView>
		)
	}

	if (loading) {
		return (
			<SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
				<ActivityIndicator size="large" />
			</SafeAreaView>
		)
	}

	if (error) {
		return (
			<SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
				<Text style={[styles.text, { color: colors.text }]}>Error loading data...</Text>
				<Button onPress={onLogout} text="Sign out" />
			</SafeAreaView>
		)
	}

	const username = data.userProfile?.username
	const email = data.userProfile?.email
	const avatarUrl = data.userProfile?.avatarUrl
	const recordings = data.userProfile?.playbacks.edges.map((edge) => {
		const recording = edge.node.recording
		return {
			id: recording.id,
			title: recording.title,
			artist: recording.orchestra?.name || 'Unknown Artist',
			duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: recording.audioTransfers[0]?.album?.albumArtUrl || '',
			url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
			genre: recording.genre.name,
			year: recording.year,
		}
	})

	return (
		<SafeAreaView style={[styles.container, { backgroundColor: colors.background }]}>
			<View style={styles.profileContainer}>
				<Image source={{ uri: avatarUrl }} style={styles.image} />
				{username && <Text style={[styles.header, { color: colors.text }]}>{username}</Text>}
				{email && <Text style={[styles.header, { color: colors.text }]}>{email}</Text>}
				<Button onPress={onLogout} text="Sign out" />
			</View>
			<View style={styles.listContainer}>
				<Text style={[styles.header, { color: colors.text }]}>History</Text>
				<FlashList
					data={recordings}
					keyExtractor={(item, index) => `${item.id}-${index}`}
					contentContainerStyle={{ paddingTop: 10, paddingBottom: 128 }}
					ListEmptyComponent={
						<View>
							<Text style={utilsStyles.emptyContentText}>No songs found</Text>
							<FastImage
								source={require('@/assets/unknown_track.png')}
								style={utilsStyles.emptyContentImage}
							/>
						</View>
					}
					ListFooterComponent={ItemDivider}
					ItemSeparatorComponent={ItemDivider}
					renderItem={({ item }) => (
						<TracksListItem track={item} onTrackSelect={handleTrackSelect} />
					)}
					estimatedItemSize={80}
				/>
			</View>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingHorizontal: 20,
		justifyContent: 'center',
		alignContent: 'center',
	},
	profileContainer: {
		alignItems: 'center',
		paddingVertical: 20,
	},
	listContainer: {
		flex: 1,
	},
	image: {
		width: 156,
		height: 156,
		borderRadius: 25,
	},
	header: {
		fontSize: 20,
		fontWeight: 'bold',
		marginVertical: 8,
	},
	text: {
		fontSize: 16,
	},
})
