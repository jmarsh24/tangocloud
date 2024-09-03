import { TracksList } from '@/components/TracksList'
import { screenPadding } from '@/constants/tokens'
import { Person } from '@/generated/graphql'
import { LIKED_RECORDINGS } from '@/graphql'
import { generateTracksListId } from '@/helpers/miscellaneous'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { ScrollView, Text, View } from 'react-native'

const FavoritesScreen = () => {
	const { data, loading, error } = useQuery(LIKED_RECORDINGS, {
		fetchPolicy: 'network-only',
	})

	const search = useNavigationSearch({
		searchBarOptions: {
			placeholder: 'Find in recordings',
		},
	})

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

  const allTracks =
    data?.currentUser?.likedRecordings?.edges.map((edge) => {
      const recording = edge.node;
      return {
        id: recording.id,
        title: recording.composition.title,
        artist: recording.recordingSingers?.edges
          .map((singerEdge : Person) => singerEdge.node.person.name)
          .join(', '),
        duration: recording.digitalRemasters.edges[0].node.duration || 0,
        artwork: recording.digitalRemasters.edges[0].node.album.albumArt.blob.url,
        genre: recording.genre?.name,
      };
    }) || [];
  const favoritesTracks = search
    ? allTracks.filter((track) =>
        track.title.toLowerCase().includes(search.toLowerCase())
      )
    : allTracks;

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
