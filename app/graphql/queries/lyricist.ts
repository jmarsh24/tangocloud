import { gql } from '@apollo/client'

export const LYRICIST = gql`
	query Lyricist($id: ID!) {
		lyricist(id: $id) {
			id
			name
			compositions {
				edges {
					node {
						id
						title
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
									audioTransfers {
										edges {
											node {
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
	}
`
