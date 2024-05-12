import { gql } from '@apollo/client'

export const SEARCH_ORCHESTRAS = gql`
	query SearchOrchestras($query: String) {
		searchOrchestras(query: $query) {
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
