import { gql } from '@apollo/client'

export const RECORDING = gql`
	query Recording($id: ID!) {
		recording(id: $id) {
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
					}
				}
			}
		}
	}
`
