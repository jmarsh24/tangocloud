import { gql } from '@apollo/client'

export const CURRENT_USER = gql`
	query CurrentUser {
		currentUser {
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
								edges {
									node {
										name
									}
								}
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
`
