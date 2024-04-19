import LikedLink from '@/components/LikedLink'
import PlaylistItem from '@/components/PlaylistItem'
import { SEARCH_PLAYLISTS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { useTheme } from '@react-navigation/native'
import { FlashList } from '@shopify/flash-list'
import React from 'react'
import { StyleSheet, Text, View } from 'react-native'

export default function HomeScreen() {
	const { colors } = useTheme()

	const {
		data: playlistsData,
		loading: playlistsLoading,
		error: playlistsError,
	} = useQuery(SEARCH_PLAYLISTS, { variables: { query: '', first: 20 } })

	if (playlistsLoading) {
		return (
			<View style={styles.container}>
				<Text>Loading playlists...</Text>
			</View>
		)
	}

	if (playlistsError) {
		return (
			<View style={styles.container}>
				<Text>Error loading playlists.</Text>
			</View>
		)
	}

	const playlists = playlistsData?.searchPlaylists?.edges.map((edge) => edge.node)

	return (
		<View style={styles.container}>
			<Text style={[styles.headerText, { color: colors.text }]}>Home</Text>
			<Text style={[styles.headerText, { color: colors.text }]}>
				The people who are crazy enough to think they can change the world are the ones who do.
			</Text>
			<FlashList
				data={playlists}
				keyExtractor={(item) => item.id}
				ListHeaderComponent={() => <LikedLink />}
				renderItem={({ item }) => <PlaylistItem playlist={item} />}
				estimatedItemSize={100}
				ListFooterComponentStyle={{ paddingBottom: 80 }}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: 'center',
		paddingHorizontal: 20,
	},
	headerText: {
		fontSize: 24,
		fontWeight: 'bold',
		textAlign: 'center',
		paddingHorizontal: 20,
		paddingVertical: 20,
	},
	playlistContainer: {
		display: 'flex',
		flexDirection: 'row',
		gap: 10,
		alignItems: 'center',
		padding: 10,
	},
	playlistTitle: {
		fontSize: 18,
		fontWeight: 'bold',
	},
	playlistImage: {
		width: 100,
		height: 100,
	},
})
