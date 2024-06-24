import { gql } from '@apollo/client'

export const PLAYLIST = gql`
	query Playlist($id: ID!) {
		playlist(id: $id) {
			id
			title
			imageUrl
			playlistItems {
				edges {
					node {
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
							edges {
								node {
									name
								}
							}
						}
						composition {
							lyrics {
								locale
								content
							}
						}
						audioTransfers {
							edges {
								node {
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
		}
	}
`
