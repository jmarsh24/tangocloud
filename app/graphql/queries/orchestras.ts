import { gql } from '@apollo/client'

export const ORCHESTRAS = gql`
	query Orchestras($query: String) {
		orchestras(query: $query) {
			edges {
				node {
					id
					name
					photoUrl
					recordingsCount
				}
			}
		}
	}
`
