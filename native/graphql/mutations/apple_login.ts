import { gql } from '@apollo/client'

export const APPLE_LOGIN = gql`
  mutation appleLogin($input: AppleLoginInput!) {
    appleLogin(input: $input) {
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
