import { gql } from '@apollo/client'

export const FETCH_PLAYLIST = gql`
	query FetchPlaylist($id: ID!) {
		fetchPlaylist(id: $id) {
			id
			title
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
`
