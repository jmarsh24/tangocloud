import { gql } from '@apollo/client'

export const PLAYLISTS = gql`
	query Playlists {
		playlists {
			edges {
				node {
					id
					title
					description
					image {
						blob {
							url
						}
					}
				}
			}
		}
	}
`
