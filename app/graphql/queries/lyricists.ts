import { gql } from '@apollo/client'

export const LYRICISTS = gql`
	query Lyricists($query: String) {
		lyricists(query: $query) {
			edges {
				node {
					id
					name
				}
			}
		}
	}
`
