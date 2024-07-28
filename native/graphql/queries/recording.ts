import { gql } from '@apollo/client'

export const RECORDING = gql`
	query Recording($id: ID!) {
		recording(id: $id) {
			digitalRemasters {
				edges {
					node {
						duration
						audioVariants {
							edges {
								node {
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
`
