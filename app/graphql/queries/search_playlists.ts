import { gql } from '@apollo/client'

export const SEARCH_PLAYLISTS = gql`
	query SearchPlaylists($query: String, $first: Int) {
		searchPlaylists(query: $query, first: $first) {
			edges {
				node {
					id
					title
					description
					imageUrl
				}
			}
			pageInfo {
				endCursor
				startCursor
				hasNextPage
				hasPreviousPage
			}
		}
	}
`
