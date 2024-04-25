import Button from '@/components/Button'
import { TracksList } from '@/components/TracksList'
import { screenPadding } from '@/constants/tokens'
import { USER_PROFILE } from '@/graphql'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useAuth } from '@/providers/AuthProvider'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { Link } from 'expo-router'
import { ActivityIndicator, Image, StyleSheet, Text, View } from 'react-native'
import { ScrollView } from 'react-native-gesture-handler'
import { SafeAreaView } from 'react-native-safe-area-context'

const YouScreen = () => {
	const { authState, onLogout } = useAuth()
	const { colors } = useTheme()

	const { data, loading, error, refetch } = useQuery(USER_PROFILE)

	if (!authState.authenticated) {
		return (
			<SafeAreaView
				edges={['right', 'top', 'left']}
				style={[defaultStyles.container, styles.container, { backgroundColor: colors.background }]}
			>
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
			<SafeAreaView
				edges={['right', 'top', 'left']}
				style={[defaultStyles.container, styles.container, { backgroundColor: colors.background }]}
			>
				<ActivityIndicator size="large" />
			</SafeAreaView>
		)
	}

	if (error) {
		return (
			<SafeAreaView
				edges={['right', 'top', 'left']}
				style={[defaultStyles.container, styles.container, { backgroundColor: colors.background }]}
			>
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
		<SafeAreaView
			edges={['right', 'top', 'left']}
			style={[defaultStyles.container, styles.container]}
		>
			<View style={styles.profileContainer}>
				<Image source={{ uri: avatarUrl }} style={styles.image} />
				{username && <Text style={[styles.header, { color: colors.text }]}>{username}</Text>}
				{email && <Text style={[styles.header, { color: colors.text }]}>{email}</Text>}
				<Button onPress={onLogout} text="Sign out" />
			</View>
			<View style={defaultStyles.container}>
				<ScrollView
					contentInsetAdjustmentBehavior="automatic"
					style={{ paddingHorizontal: screenPadding.horizontal }}
				>
					<TracksList
						id={generateTracksListId('recordings')}
						tracks={recordings}
						scrollEnabled={false}
						hideQueueControls={true}
					/>
				</ScrollView>
			</View>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
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

export default YouScreen
