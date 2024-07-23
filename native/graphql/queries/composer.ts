import { gql } from '@apollo/client'

export const COMPOSER = gql`
	query Composer($id: ID!) {
		composer(id: $id) {
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
