import { gql } from '@apollo/client';

export const USER_PROFILE = gql`
	query userProfile {
		currentUser {
			id
			username
			userPreference {
				id
				avatar {
					blob {
						url
					}
				}
			}
			playbacks {
				edges {
					node {
						recording {
							id
							composition {
								title
							}
							genre {
								name
							}
							year
							orchestra {
								name
							}
							digitalRemasters {
								edges {
									node {
										duration
										album {
											albumArt {
												blob {
													url
												}
											}
										}
										audioVariants {
											edges {
												node {
													audioFile {
														blob {
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
			}
		}
	}
`;
