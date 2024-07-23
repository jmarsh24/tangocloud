import { gql } from '@apollo/client'

export const ORCHESTRA = gql`
	query Orchestra($id: ID!) {
		orchestra(id: $id) {
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
