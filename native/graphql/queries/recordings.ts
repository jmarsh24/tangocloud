import { gql } from '@apollo/client'

export const RECORDINGS = gql`
	query Recordings($query: String, $sortBy: String, $order: String, $first: Int, $after: String) {
		recordings(query: $query, sortBy: $sortBy, order: $order, first: $first, after: $after) {
			edges {
				node {
					id
					title
					recordedDate
					orchestra {
						name
					}
					singers {
						edges {
							node {
								name
							}
						}
					}
					genre {
						name
					}
					composition {
						lyrics {
							edges {
								node {
									locale
									content
								}
							}
						}
					}
					year
					audioTransfers {
						edges {
							node {
								id
								album {
									albumArtUrl
								}
								audioVariants {
									edges {
										node {
											id
											duration
											audioFileUrl
										}
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
