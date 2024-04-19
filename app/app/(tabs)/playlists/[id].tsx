import { PlaylistTracksList } from '@/components/PlaylistTracksList'
import { screenPadding } from '@/constants/tokens'
import { FETCH_PLAYLIST } from '@/graphql'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { Redirect, useLocalSearchParams } from 'expo-router'
import { ScrollView, Text, View } from 'react-native'

const PlaylistScreen = () => {
	const { id } = useLocalSearchParams<{ id: string }>()
	const { data, loading, error } = useQuery(FETCH_PLAYLIST, {
		variables: { id: id },
		fetchPolicy: 'network-only',
	})
	
	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<Text>Loading...</Text>
			</View>
		)
	}

	if (error) {
		console.error('Error fetching playlist:', error)
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading playlist. Please try again later.</Text>
			</View>
		)
	}

	const playlist = data?.fetchPlaylist
	const playlistTitle = data?.fetchPlaylist?.title

	if (!playlist) {
		console.warn(`Playlist ${playlistTitle} was not found!`)

		return <Redirect href={'/(tabs)/playlists'} />
	}

	return (
		<View style={defaultStyles.container}>
			<ScrollView
				contentInsetAdjustmentBehavior="automatic"
				style={{ paddingHorizontal: screenPadding.horizontal }}
			>
				<PlaylistTracksList playlist={playlist} />
			</ScrollView>
		</View>
	)
}

export default PlaylistScreen
