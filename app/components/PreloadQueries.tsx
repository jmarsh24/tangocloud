import {
	FETCH_LIKED_RECORDINGS,
	SEARCH_PLAYLISTS,
	SEARCH_RECORDINGS,
	USER_PROFILE,
} from '@/graphql'
import { useQuery } from '@apollo/client'

const PreloadQueries = () => {
	const {
		data: likedRecordingsData,
		loading: likedRecordingsLoading,
		error: likedRecordingsError,
	} = useQuery(FETCH_LIKED_RECORDINGS)
	const {
		data: searchPlaylistsData,
		loading: searchPlaylistsLoading,
		error: searchPlaylistsError,
	} = useQuery(SEARCH_PLAYLISTS, {
		variables: { query: '*' },
	})
	const {
		data: searchRecordingsData,
		loading: searchRecordingsLoading,
		error: searchRecordingsError,
	} = useQuery(SEARCH_RECORDINGS, {
		variables: { query: '*', first: 50 },
	})
	const {
		data: userProfileData,
		loading: userProfileLoading,
		error: userProfileError,
	} = useQuery(USER_PROFILE)

	if (
		likedRecordingsLoading ||
		searchPlaylistsLoading ||
		searchRecordingsLoading ||
		userProfileLoading
	) {
		console.log('Queries are loading...')
	}

	if (likedRecordingsError || searchPlaylistsError || searchRecordingsError || userProfileError) {
		console.error(
			'Error preloading queries:',
			likedRecordingsError || searchPlaylistsError || searchRecordingsError || userProfileError,
		)
	}

	if (likedRecordingsData && searchPlaylistsData && searchRecordingsData && userProfileData) {
		console.log('Queries are loaded')
	}

	return null
}

export default PreloadQueries
