import { gql } from '@apollo/client'

export const TANDA_OF_THE_WEEK = gql`
	query TandaOfTheWeek($query: String, $first: Int) {
		playlists(query: $query, first: $first) {
			edges {
				node {
					id
					title
					description
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
												edges {
													node {
														locale
														content
													}
												}
											}
										}
										audioTransfers {
											edges {
												node {
													id
													audioVariants {
														edges {
															node {
																audioFileUrl
																duration
															}
														}
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
