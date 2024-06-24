import { gql } from '@apollo/client'

export const LIKED_RECORDINGS = gql`
	query LikedRecordings {
		recordings {
			edges {
				node {
					id
					title
					year
					genre {
						name
					}
					singers {
						edges {
							node {
								name
							}
						}
					}
					orchestra {
						name
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
								album {
									id
									albumArtUrl
								}
								audioVariants {
									edges {
										node {
											id
											audioFileUrl
											duration
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
