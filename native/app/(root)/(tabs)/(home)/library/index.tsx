import { FETCH_LIKED_RECORDINGS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useFocusEffect, useTheme } from '@react-navigation/native'
import { useCallback } from 'react'
import { ActivityIndicator, StyleSheet, Text, View } from 'react-native'

export default function LibrarysScreen() {
	const { colors } = useTheme()
	const { data: recordings, loading, error, refetch } = useQuery(FETCH_LIKED_RECORDINGS)

	useFocusEffect(
		useCallback(() => {
			refetch()
		}, [refetch]),
	)

	if (loading) {
		return (
			<View style={styles.container}>
				<ActivityIndicator />
			</View>
		)
	}
	if (error) {
		return (
			<View style={styles.container}>
				<Text>Failed to fetch</Text>
			</View>
		)
	}

	const tracks =
		recordings?.fetchLikedRecordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.composition.title,
			artist: edge.node.orchestra.name,
			duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || '',
			url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
			genre: edge.node.genre.name,
			year: edge.node.year,
			singer: edge.node.singers[0]?.name,
		})) || []

	return (
		<View style={styles.container}>
			<Text style={[styles.title, { color: colors.text }]}>Liked Recordings</Text>
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
		fontWeight: 'bold',
		alignSelf: 'center',
		marginVertical: 10,
	},
	itemSeparator: {
		height: 1,
	},
})
