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
									language {
										name
									}
									text
								}
							}
						}
					}
					digitalRemasters {
						edges {
							node {
								id
								album {
									id
									albumArt {
										url
									}
								}
								duration
								audioVariants {
									edges {
										node {
											id
											audioFile {
												url
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
`
