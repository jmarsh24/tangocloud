import { PlaylistButton } from '@/components/PlaylistButton'
import { screenPadding } from '@/constants/tokens'
import { SEARCH_PLAYLISTS } from '@/graphql'
import { defaultStyles } from '@/styles'
import { useQuery } from '@apollo/client'
import { Link } from 'expo-router'
import { useMemo } from 'react'
import { ActivityIndicator, FlatList, SafeAreaView, Text, View } from 'react-native'

const HomeScreen = () => {
	const {
		data: playlistData,
		loading: playlistLoading,
		error: playlistsError,
	} = useQuery(SEARCH_PLAYLISTS, {
		variables: { query: '*', first: 10 },
	})

	const playlists = useMemo(() => {
		return playlistData?.searchPlaylists?.edges.map((edge) => edge.node) ?? []
	}, [playlistData])

	if (playlistLoading) {
		return <ActivityIndicator size="large" color="#0000ff" />
	}

	if (playlistsError) {
		return <Text>Error loading playlists: {playlistsError.message}</Text>
	}

	return (
		<SafeAreaView style={{ flex: 1 }}>
			<View style={{ ...defaultStyles.container, paddingHorizontal: screenPadding.horizontal }}>
				<FlatList
					data={playlists}
					renderItem={({ item }) => <PlaylistButton playlist={item} />}
					numColumns={2}
					keyExtractor={(item) => item.id}
					columnWrapperStyle={{ gap: 20 }}
					scrollEnabled={false}
					style={{ backgroundColor: 'red', flexGrow: 0 }}
				/>
				<Link style={defaultStyles.text} href="/playlists">
					See All Playlists
				</Link>
			</View>
		</SafeAreaView>
	)
}

export default HomeScreen
