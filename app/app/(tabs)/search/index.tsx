import TrackListItem from '@/components/TrackListItem'
import { SEARCH_RECORDINGS } from '@/graphql'
import { useQuery } from '@apollo/client'
import { AntDesign } from '@expo/vector-icons'
import { useTheme } from '@react-navigation/native'
import { FlashList } from '@shopify/flash-list'
import { Link } from 'expo-router'
import { useState } from 'react'
import { StyleSheet, Text, TextInput, View } from 'react-native'
import { defaultStyles }	from '@/styles'

const SearchScreen = () => {
	const { colors } = useTheme()
	const ITEMS_PER_PAGE = 200
	const [search, setSearch] = useState('')

	const { data, loading, error } = useQuery(SEARCH_RECORDINGS, {
		variables: { query: search, first: ITEMS_PER_PAGE }
	});

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

	const tracks =
		data?.searchRecordings.edges.map((edge) => ({
			id: edge.node.id,
			title: edge.node.title,
			artist: edge.node.orchestra.name,
			duration: edge.node.audioTransfers[0]?.audioVariants[0]?.duration || 0,
			artwork: edge.node.audioTransfers[0]?.album?.albumArtUrl || '',
			url: edge.node.audioTransfers[0]?.audioVariants[0]?.audioFileUrl || '',
			genre: edge.node.genre.name,
			year: edge.node.year,
			singer: edge.node.singers[0]?.name,
		})) || []

	return (
		<View style={defaultStyles.container}>
			<View style={[styles.header, { backgroundColor: colors.background }]}>
				<View style={[styles.searchContainer, { backgroundColor: colors.card }]}>
					<AntDesign name="search1" size={20} style={[styles.searchIcon, { color: colors.text }]} />
					<TextInput
						value={search}
						onChangeText={setSearch}
						placeholder="What do you want to listen to?"
						autoCorrect={false}
						autoComplete="off"
						autoCapitalize="none"
						style={[styles.input, { color: colors.text, backgroundColor: colors.card }]}
					/>
					{search.length > 0 && (
						<AntDesign
							name="close"
							size={20}
							style={[styles.clearIcon, { color: colors.text }]}
							onPress={() => setSearch('')}
						/>
					)}
				</View>
			</View>
			{search.length === 0 && (
				<View style={styles.linksContainer}>
					<Link
						style={[styles.linkButton, { backgroundColor: colors.card }]}
						push
						href="/orchestras"
					>
						<Text style={[styles.buttonText, { color: colors.text }]}>Orchestras</Text>
					</Link>
					<Link style={[styles.linkButton, { backgroundColor: colors.card }]} push href="/singers">
						<Text style={[styles.buttonText, { color: colors.text }]}>Singers</Text>
					</Link>
					<Link
						style={[styles.linkButton, { backgroundColor: colors.card }]}
						push
						href="/composers"
					>
						<Text style={[styles.buttonText, { color: colors.text }]}>Composers</Text>
					</Link>
					<Link
						style={[styles.linkButton, { backgroundColor: colors.card }]}
						push
						href="/lyricists"
					>
						<Text style={[styles.buttonText, { color: colors.text }]}>Lyricists</Text>
					</Link>
				</View>
			)}
			<FlashList
				data={tracks}
				renderItem={({ item }) => <TrackListItem track={item} tracks={tracks} />}
				ItemSeparatorComponent={() => <View style={styles.itemSeparator} />}
				showsVerticalScrollIndicator={false}
				estimatedItemSize={75}
				ListFooterComponentStyle={{ paddingBottom: 80 }}
			/>
		</View>
	)
}

const styles = StyleSheet.create({
	header: {
		// flexDirection: 'row',
		// justifyContent: 'space-between',
		// alignItems: 'center',
		// gap: 10,
	},
	linksContainer: {
		// flexDirection: 'row',
		// flexWrap: 'wrap',
		// justifyContent: 'space-between',
		// gap: 10,
		// paddingTop: 10,
	},
	linkButton: {
		width: '48%',
		padding: 30,
	},
	button: {
		padding: 10,
		borderWidth: 1,
		borderRadius: 5,
		alignItems: 'center',
	},
	searchContainer: {
		flex: 1,
		flexDirection: 'row',
		alignItems: 'center',
		padding: 8,
		borderRadius: 5,
		position: 'relative',
	},
	input: {
		flex: 1,
		paddingVertical: 4,
		paddingLeft: 30,
		paddingRight: 4,
	},
	searchIcon: {
		position: 'absolute',
		left: 10,
		zIndex: 1,
	},
	clearIcon: {
		position: 'absolute',
		right: 10,
	},
	footerStyle: {
		height: 100,
	},
	itemSeparator: {
		height: 10,
	},
	buttonText: {
		fontSize: 16,
		fontWeight: 'bold',
		textAlign: 'center',
	},
})

export default SearchScreen
