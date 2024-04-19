import { TracksList } from '@/components/TracksList'
import { screenPadding } from '@/constants/tokens'
import { SEARCH_RECORDINGS } from '@/graphql'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { Link } from 'expo-router'
import React, { useMemo, useState } from 'react'
import { ScrollView, Text, View } from 'react-native'

const SearchScreen = () => {
	const { colors } = useTheme()
	const [searchQuery, setSearchQuery] = useState('')
	const ITEMS_PER_PAGE = 50

	const searchText = useNavigationSearch({
		searchBarOptions: { placeholder: 'Find in recordings' },
	})

	useMemo(() => setSearchQuery(searchText), [searchText])

	const { data, loading, error } = useQuery(SEARCH_RECORDINGS, {
		variables: { query: searchQuery || '*', first: ITEMS_PER_PAGE },
	})

	const tracks = useMemo(() => {
		return (
			data?.searchRecordings?.edges.map((edge) => ({
				id: edge.node.id,
				title: edge.node.title,
				artist: edge.node.orchestra.name,
				duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
				artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || '',
				url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
				singer: edge.node.singers[0]?.name || '',
				year: edge.node.year || '',
				genre: edge.node.genre.name || '',
			})) || []
		)
	}, [data])

	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<Text>Loading...</Text>
			</View>
		)
	}

	if (error) {
		console.error('Error fetching recordings:', error)
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading recordings. Please try again later.</Text>
			</View>
		)
	}

	const navigationLinks = ['orchestras', 'singers', 'composers', 'lyricists'].map((category) => (
		<Link
			key={category}
			href={`/${category}`}
			push
			style={[defaultStyles.linkButton, { backgroundColor: colors.card }]}
		>
			<Text style={[defaultStyles.buttonText, { color: colors.text }]}>
				{category[0].toUpperCase() + category.slice(1)}
			</Text>
		</Link>
	))

	return (
		<View style={defaultStyles.container}>
			{!searchQuery && <View style={defaultStyles.linksContainer}>{navigationLinks}</View>}
			<ScrollView
				contentInsetAdjustmentBehavior="automatic"
				style={{ paddingHorizontal: screenPadding.horizontal }}
			>
				<TracksList
					id={generateTracksListId('songs', searchQuery)}
					tracks={tracks}
					scrollEnabled={false}
					hideQueueControls={true}
				/>
			</ScrollView>
		</View>
	)
}

export default SearchScreen
