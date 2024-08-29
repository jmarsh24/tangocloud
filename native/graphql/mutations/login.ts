import { gql } from '@apollo/client'

export const LOGIN = gql`
	mutation login($login: String!, $password: String!) {
		login(input: { login: $login, password: $password }) {
			__typename
			... on AuthenticatedUser {
				id
				email
				username
				session {
					access
					accessExpiresAt
					refresh
					refreshExpiresAt
				}
			}
			... on FailedLogin {
				error
			}
		}
	}
`
