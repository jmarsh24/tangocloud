import {
	FETCH_LIKED_RECORDINGS,
	SEARCH_PLAYLISTS,
	SEARCH_RECORDINGS,
	USER_PROFILE,
} from '@/graphql'
import { useQuery } from '@apollo/client'
import { useEffect, useState } from 'react'
import { Text } from 'react-native'

const PreloadQueries = () => {
	const [initialized, setInitialized] = useState(false)

	const handleQueryCompleted = () => {
		if (!initialized) {
			console.log('Queries are loaded')
			setInitialized(true)
		}
	}

	const likedRecordingsQuery = useQuery(FETCH_LIKED_RECORDINGS, {
		onCompleted: handleQueryCompleted,
	})
	const searchPlaylistsQuery = useQuery(SEARCH_PLAYLISTS, {
		variables: { query: '*' },
		onCompleted: handleQueryCompleted,
	})
	const searchRecordingsQuery = useQuery(SEARCH_RECORDINGS, {
		variables: { query: '*', first: 50 },
		onCompleted: handleQueryCompleted,
	})
	const userProfileQuery = useQuery(USER_PROFILE, { onCompleted: handleQueryCompleted })

	useEffect(() => {
		const hasError =
			likedRecordingsQuery.error ||
			searchPlaylistsQuery.error ||
			searchRecordingsQuery.error ||
			userProfileQuery.error

		if (hasError) {
			console.error(
				'Error preloading queries:',
				likedRecordingsQuery.error ||
					searchPlaylistsQuery.error ||
					searchRecordingsQuery.error ||
					userProfileQuery.error,
			)
		}
	}, [
		likedRecordingsQuery.error,
		searchPlaylistsQuery.error,
		searchRecordingsQuery.error,
		userProfileQuery.error,
	])

	if (
		likedRecordingsQuery.loading ||
		searchPlaylistsQuery.loading ||
		searchRecordingsQuery.loading ||
		userProfileQuery.loading
	) {
		console.log('Queries are loading...')
	}

	if (!initialized) {
		return <LoadingIndicator />
	}

	return null
}

const LoadingIndicator = () => {
	return <Text>Loading data...</Text>
}

export default PreloadQueries
