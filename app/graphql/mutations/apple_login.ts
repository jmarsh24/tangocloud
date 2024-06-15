import { gql } from '@apollo/client'

export const APPLE_LOGIN = gql`
	mutation appleLogin(
		$userIdentifier: String!
		$email: String
		$firstName: String
		$lastName: String
	) {
		appleLogin(
			input: {
				userIdentifier: $userIdentifier
				email: $email
				firstName: $firstName
				lastName: $lastName
			}
		) {
			user {
				id
				username
				email
			}
			token
		}
	}
`
