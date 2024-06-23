import { gql } from '@apollo/client'

export const COMPOSERS = gql`
	query Composers($query: String) {
		composers(query: $query) {
			edges {
				node {
					id
					name
				}
			}
		}
	}
`
