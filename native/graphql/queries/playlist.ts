import { gql } from '@apollo/client'

export const PLAYLIST = gql`
	query Playlist($id: ID!) {
		playlist(id: $id) {
			id
			title
			image {
				url
			}
			playlistItems {
				edges {
					node {
						id
						item {
							... on Recording {
								id
								composition {
									title
								}
								orchestra {
									name
									image {
										url
									}
								}
								digitalRemasters {
									edges {
										node {
											duration
											album {
												albumArt {
													url
												}
											}
											audioVariants {
												edges {
													node {
														id
														url
													}
												}
											}
										}

                	}
								}
								genre {
									name
								}
								year
								singers {
                  edges {
                    node {
                      name
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
`
