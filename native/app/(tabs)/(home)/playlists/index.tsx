import { PlaylistsList } from '@/components/PlaylistsList'
import { screenPadding } from '@/constants/tokens'
import { PLAYLISTS } from '@/graphql'
import { Playlist } from '@/generated/graphql'
import { useNavigationSearch } from '@/hooks/useNavigationSearch'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { useRouter } from 'expo-router'
import { useMemo } from 'react'
import { ScrollView, Text, View } from 'react-native'

const PlaylistsScreen = () => {
	const router = useRouter()

	const search = useNavigationSearch({
		searchBarOptions: {
			placeholder: 'Find in playlists',
		},
	})

	const { data, loading, error } = useQuery(PLAYLISTS, {
		fetchPolicy: 'cache-and-network',
	})

	const playlists = useMemo(() => {
		return data?.playlists?.edges.map((edge) => edge.node) ?? []
	}, [data])

	const handlePlaylistPress = (playlist: Playlist) => {
		router.push(`/playlists/${playlist.id}`)
	}

	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<Text>Loading...</Text>
			</View>
		)
	}

	if (error) {
		console.error('Error fetching playlists:', error)
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading playlists.</Text>
			</View>
		)
	}

	return (
		<View style={defaultStyles.container}>
			<ScrollView
				contentInsetAdjustmentBehavior="automatic"
				style={{
					paddingHorizontal: screenPadding.horizontal,
				}}
			>
				<PlaylistsList
					scrollEnabled={false}
					playlists={playlists}
					onPlaylistPress={handlePlaylistPress}
				/>
			</ScrollView>
		</View>
	)
}

export default PlaylistsScreen
