import { gql } from '@apollo/client'

export const TANDA_OF_THE_WEEK = gql`
	query SearchPlaylists($query: String, $first: Int) {
		searchPlaylists(query: $query, first: $first) {
			edges {
				node {
					id
					title
					description
					imageUrl
					playlistItems {
						id
						playable {
							... on Recording {
								id
								title
								year
								genre {
									name
								}
								orchestra {
									name
								}
								singers {
									name
								}
								composition {
									lyrics {
										locale
										content
									}
								}
								audioTransfers {
									id
									audioVariants {
										audioFileUrl
										duration
									}
									album {
										albumArtUrl
									}
								}
							}
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
