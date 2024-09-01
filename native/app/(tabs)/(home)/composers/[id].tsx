import { FETCH_COMPOSER } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { useLocalSearchParams } from 'expo-router'
import { useEffect } from 'react'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'

export default function ComposerScreen() {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { colors } = useTheme()

	const { data, loading, error } = useQuery(FETCH_COMPOSER, { variables: { id: id } })

	useEffect(() => {
		if (error) {
			console.error('Error fetching composer:', error)
		}
	}, [error])

	if (loading) {
		return (
			<View style={styles.container}>
				<ActivityIndicator size="large" />
			</View>
		)
	}

	if (error) {
		return (
			<View style={styles.container}>
				<Text>Error loading composer.</Text>
			</View>
		)
	}

	const recordings = data?.fetchComposer.compositions.edges.flatMap(({ node: composition }) =>
		composition.recordings.edges.map(({ node: recording }) => ({
			id: recording.id,
			title: recording.composition.title,
			artist: data.fetchComposer.name,
			duration: recording.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: recording.audioTransfers[0]?.album?.albumArtUrl,
			url: recording.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
			year: recording.year,
			genre: recording.genre.name,
			singer: recording.singers[0]?.name,
		})),
	)

	return (
		<View style={styles.container}>
			<Text style={[styles.title, { color: colors.text }]}>{data.fetchComposer.name}</Text>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		paddingHorizontal: 20,
	},
	title: {
		fontSize: 24,
		marginBottom: 20,
		fontWeight: 'bold',
	},
})
