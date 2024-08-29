import { gql } from '@apollo/client'

export const RECORDINGS = gql`
	query Recordings($query: String) {
		recordings {
			edges {
				node {
					id
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
									id
									text
									language {
										name
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
