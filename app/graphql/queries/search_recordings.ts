import { gql } from '@apollo/client'

export const SEARCH_RECORDINGS = gql`
	query SearchRecordings(
		$query: String
		$sortBy: String
		$order: String
		$first: Int
		$after: String
	) {
		searchRecordings(query: $query, sortBy: $sortBy, order: $order, first: $first, after: $after) {
			edges {
				node {
					id
					title
					recordedDate
					orchestra {
						name
					}
					singers {
						name
					}
					genre {
						name
					}
					composition {
						lyrics {
							content
						}
					}
					year
					audioTransfers {
						album {
							albumArtUrl
						}
						audioVariants {
							id
							duration
							audioFileUrl
						}
					}
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
