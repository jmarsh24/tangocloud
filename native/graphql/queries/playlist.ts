import { gql } from '@apollo/client'

export const PLAYLIST = gql`
	query Playlist($id: ID!) {
		playlist(id: $id) {
			id
			title
			image {
				blob {
					url
				}
			}
			playlistItems {
				edges {
					node {
						id
						item {
							... on Recording {
								id
								title
								orchestra {
									name
									image {
										blob {
											url
										}
									}
								}
								digitalRemasters {
									edges {
										node {
											duration
											album {
												albumArt {
													blob {
														url
													}
												}
											}
											audioVariants {
												edges {
													node {
														audioFile {
															blob {
																url
															}
														}
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
