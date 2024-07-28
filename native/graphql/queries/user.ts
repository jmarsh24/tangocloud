import { gql } from '@apollo/client'

export const USER = gql`
  query User($id: ID!) {
    user(id: $id) {
      id
      email
      username
      admin
			userPreference {
				firstName
				lastName
			}
    }
  }
`
