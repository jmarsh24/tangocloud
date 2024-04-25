import { TracksList } from '@/components/TracksList'
import { screenPadding } from '@/constants/tokens'
import { FETCH_LIKED_RECORDINGS } from '@/graphql'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useMemo } from 'react'
import { ScrollView, Text, View } from 'react-native'

const FavoritesScreen = () => {
	const { data, loading, error } = useQuery(FETCH_LIKED_RECORDINGS, {
		fetchPolicy: 'cache-and-network',
	})

	const search = useNavigationSearch({
		searchBarOptions: {
			placeholder: 'Find in recordings',
		},
	})

	// Processing data to get favorites tracks, now filtered based on search
	const favoritesTracks = useMemo(() => {
		const allTracks =
			data?.fetchLikedRecordings?.edges.map((edge) => ({
				id: edge.node.id,
				title: edge.node.title,
				artist: edge.node.orchestra?.name || 'Unknown Orchestra',
				duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
				artwork:
					edge.node.audioTransfers[0]?.album?.albumArtUrl || require('@/assets/unknown_track.png'),
				url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
				singer: edge.node.singers?.map((s) => s.name).join(', ') || 'Various Artists',
				year: edge.node.year || 'Unknown Year',
				genre: edge.node.genre?.name || 'Unknown Genre',
			})) || []

		return search
			? allTracks.filter((track) => track.title.toLowerCase().includes(search.toLowerCase()))
			: allTracks
	}, [data, search])

	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<Text>Loading...</Text>
			</View>
		)
	}

	if (error) {
		console.error('Error fetching liked recordings:', error)
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading liked recordings. Please try again later.</Text>
			</View>
		)
	}

	return (
		<View style={defaultStyles.container}>
			<ScrollView
				style={{ paddingHorizontal: screenPadding.horizontal }}
				contentInsetAdjustmentBehavior="automatic"
			>
				<TracksList
					id={generateTracksListId('favorites', search)}
					tracks={favoritesTracks}
					scrollEnabled={false}
				/>
			</ScrollView>
		</View>
	)
}

export default FavoritesScreen
