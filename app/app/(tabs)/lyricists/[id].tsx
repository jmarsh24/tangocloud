import { FETCH_LYRICIST } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { Stack, useLocalSearchParams } from 'expo-router'
import { useEffect } from 'react'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'

const LyricistScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { colors } = useTheme()

	const { data, loading, error } = useQuery(FETCH_LYRICIST, { variables: { id } })

	useEffect(() => {
		if (error) {
			console.error('Error fetching lyricist:', error)
		}
	}, [error])

	if (loading) {
		return (
			<View style={styles.container}>
				<ActivityIndicator size="large" color={colors.primary} />
			</View>
		)
	}

	if (error) {
		return (
			<View style={styles.container}>
				<Text>Error loading lyricist.</Text>
			</View>
		)
	}

	const recordings = data?.fetchLyricist.compositions.edges.flatMap(({ node: composition }) =>
		composition.recordings.edges.map(({ node: recording }) => ({
			id: recording.id,
			title: recording.title,
			artist: data.fetchLyricist.name,
			duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: recording.audioTransfers[0]?.album?.albumArtUrl,
			url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
			year: recording.year,
			genre: recording.genre.name,
			singer: recording.singers[0]?.name,
		})),
	)

	return (
		<SafeAreaView edges={['right', 'top', 'left']} style={styles.container}>
			<Stack.Screen options={{ title: data.fetchLyricist.name }} />
			<Text style={[styles.title, { color: colors.text }]}>{data.fetchLyricist.name}</Text>
		</SafeAreaView>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingHorizontal: 10,
	},
	title: {
		fontSize: 24,
		marginBottom: 20,
		fontWeight: 'bold',
	},
})

export default LyricistScreen
