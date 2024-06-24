import { gql } from '@apollo/client'

export const PLAYLISTS = gql`
	query Playlists($query: String, $first: Int) {
		playlists(query: $query, first: $first) {
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
