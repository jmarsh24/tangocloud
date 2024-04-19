import { useState, useMemo } from 'react';
import { ScrollView, View, Text } from 'react-native';
import { useQuery } from '@apollo/client';

import { useTheme } from '@react-navigation/native'
import { useNavigationSearch } from '@/hooks/useNavigationSearch';
import { trackTitleFilter } from '@/helpers/filter';
import { generateTracksListId } from '@/helpers/miscellaneous';

import { SEARCH_RECORDINGS } from '@/graphql';
import { TracksList } from '@/components/TracksList';
import { defaultStyles } from '@/styles';
import { screenPadding } from '@/constants/tokens';

const SearchScreen = () => {
	const { colors } = useTheme();
	const [searchQuery, setSearchQuery] = useState('');
	const ITEMS_PER_PAGE = 50;

	const { data, loading, error } = useQuery(SEARCH_RECORDINGS, {
		variables: { query: searchQuery, first: ITEMS_PER_PAGE }
	});

	const tracks = useTracks();

	const filteredTracks = useMemo(() => {
		return searchQuery ? tracks.filter(trackTitleFilter(searchQuery)) : tracks;
	}, [searchQuery, tracks]);

	const searchProps = useNavigationSearch({
		searchBarOptions: {
			placeholder: 'Find in songs',
		},
		onSearch: setSearchQuery,
	});

	if (loading) {
		return (
			<View style={defaultStyles.container}>
				<Text>Loading...</Text>
			</View>
		);
	}

	if (error) {
		console.error('Error fetching recordings:', error);
		return (
			<View style={defaultStyles.container}>
				<Text>Error loading recordings. Please try again later.</Text>
			</View>
		);
	}

	const navigationLinks = (
		<View style={defaultStyles.linksContainer}>
			{['orchestras', 'singers', 'composers', 'lyricists'].map((category) => (
				<Link key={category}
					to={`/${category}`}
					push
					style={[defaultStyles.linkButton, { backgroundColor: colors.card }]}
				>
					<Text style={[defaultStyles.buttonText, { color: colors.text }]}>{category.charAt(0).toUpperCase() + category.slice(1)}</Text>
				</Link>
			))}
		</View>
	);

	return (
		<View style={defaultStyles.container}>
			{searchQuery.length === 0 && navigationLinks}
			<ScrollView
				contentInsetAdjustmentBehavior="automatic"
				style={{ paddingHorizontal: screenPadding.horizontal }}
			>
				<TracksList
					id={generateTracksListId('songs', searchQuery)}
					tracks={filteredTracks}
					scrollEnabled={false}
				/>
			</ScrollView>
		</View>
	);
};

export default SearchScreen;
