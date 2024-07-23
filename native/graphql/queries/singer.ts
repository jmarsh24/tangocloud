import { gql } from '@apollo/client'

export const SINGER = gql`
	query Singer($id: ID!) {
		singer(id: $id) {
			id
			name
			photoUrl
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
`
