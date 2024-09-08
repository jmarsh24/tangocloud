import { FETCH_SINGER } from '@/graphql'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { useLocalSearchParams } from 'expo-router'
import { useEffect } from 'react'
import { ActivityIndicator, Image, StyleSheet, Text, View } from 'react-native'

const SingerScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { colors } = useTheme()

	const { data, loading, error } = useQuery(FETCH_SINGER, { variables: { id } })

	useEffect(() => {
		if (error) {
			console.error('Error fetching singer:', error)
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
				<Text>Error loading singer.</Text>
			</View>
		)
	}

	const singer = data?.fetchSinger

	const recordings = singer.recordings.edges.map(({ node: item }) => ({
		id: item.id,
		title: item.title,
		artist: item.orchestra ? item.orchestra.name : 'Unknown',
		duration: item.audioTransfers[0]?.audioVariants[0]?.duration || 0,
		artwork: item.audioTransfers[0]?.album?.albumArtUrl,
		url: item.audioTransfers[0]?.audioVariants[0]?.audioFileUrl,
		year: item.year,
		genre: item.genre.name,
		singer: item.singers[0]?.name,
	}))

	return (
		<View style={defaultStyles.container}>
			<View style={styles.imageContainer}>
				{singer.photoUrl && <Image source={{ uri: singer.photoUrl }} style={styles.image} />}
				<Text style={[styles.title, { color: colors.text }]}>{singer.name}</Text>
			</View>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
	},
	imageContainer: {
		alignItems: 'center',
		marginBottom: 20,
	},
	image: {
		width: '100%',
		height: 200,
		position: 'relative',
	},
	title: {
		position: 'absolute',
		bottom: 0,
		left: 0,
		fontSize: 24,
		fontWeight: 'bold',
		textAlign: 'center',
		paddingLeft: 10,
		paddingBottom: 10,
	},
})

export default SingerScreen
