import { gql } from '@apollo/client'

export const USER = gql`
	query User($id: ID!) {
		user(id: $id) {
			id
			name
			email
			username
			firstName
			lastName
			admin
		}
	}
`
