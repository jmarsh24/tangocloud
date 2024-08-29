import { gql } from '@apollo/client'

export const REGISTER = gql`
	mutation register($username: String, $email: String!, $password: String!) {
		register(input: { username: $username, email: $email, password: $password }) {
			... on AuthenticatedUser {
				id
				username
				email
				session {
					access
					accessExpiresAt
					refresh
					refreshExpiresAt
				}
			}
			... on ValidationError {
				errors {
					fullMessages
					attributeErrors {
						attribute
						errors
					}
				}
			}
		}
	}
`
