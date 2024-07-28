import { gql } from '@apollo/client'

export const GOOGLE_LOGIN = gql`
	mutation googleLogin($idToken: String!) {
        googleLogin(input: {
          idToken: $idToken
        }) {
         __typename
          ...on AuthenticatedUser {
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
          ...on FailedLogin {
            error
          }
        }
	}
`
