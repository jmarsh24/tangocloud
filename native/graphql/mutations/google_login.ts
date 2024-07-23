import { gql } from '@apollo/client'

export const GOOGLE_LOGIN = gql`
	mutation googleLogin($idToken: String!) {
		googleLogin(input: { idToken: $idToken }) {
			user {
				id
				username
				email
			}
			token
		}
	}
`
