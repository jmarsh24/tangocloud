import { PlaylistButton } from '@/components/PlaylistButton'
import { colors, screenPadding } from '@/constants/tokens'
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
		variables: { query: '*' },
	})


	const playlists = useMemo(() => {
		const items = playlistData?.searchPlaylists?.edges.map(edge => edge.node) ?? [];
		return items.sort(() => Math.random() - 0.5).slice(0, 8);
	}, [playlistData]);

	if (playlistLoading) {
		return <ActivityIndicator size="large" color="#0000ff" />
	}

	if (playlistsError) {
		return <Text>Error loading playlists: {playlistsError.message}</Text>
	}

	return (
		<SafeAreaView style={{ flex: 1 }}>
			<View
				style={{
					...defaultStyles.container,
					paddingHorizontal: screenPadding.horizontal,
					display: 'flex',
					gap: 24,
				}}
			>
				<FlatList
					data={playlists}
					renderItem={({ item }) => <PlaylistButton playlist={item} />}
					numColumns={2}
					keyExtractor={(item) => item.id}
					columnWrapperStyle={{ gap: 8 }}
					contentContainerStyle={{ gap: 8 }}
					scrollEnabled={false}
					style={{ flexGrow: 0 }}
				/>
				<Link style={[defaultStyles.text, { color: colors.primary }]} href="/playlists">
					See All Playlists
				</Link>
			</View>
		</SafeAreaView>
	)
}

export default HomeScreen
