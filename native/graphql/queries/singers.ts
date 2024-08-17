import { gql } from '@apollo/client'

export const SINGERS = gql`
	query Singers($query: String) {
		singers(query: $query) {
			edges {
				node {
					id
					name
					image {
						url
					}
				}
			}
		}
	}
`
