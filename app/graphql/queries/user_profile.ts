import { gql } from '@apollo/client'

export const USER_PROFILE = gql`
	query UserProfile {
		userProfile {
			id
			email
			username
			name
			firstName
			lastName
			verified
			admin
			avatarUrl
			createdAt
			updatedAt
			playbacks {
				edges {
					node {
						id
						recording {
							id
							title
							orchestra {
								name
							}
							genre {
								name
							}
							year
							singers {
								name
							}
							composition {
								lyrics {
									content
								}
							}
							audioTransfers {
								audioVariants {
									audioFileUrl
									duration
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
`
