import { gql } from '@apollo/client';

export const CURRENT_USER = gql`
  query currentUser {
    currentUser {
      id
      email
      username
      userPreference {
        firstName
        lastName
        avatar {
          blob {
            url
          }
        }
      }
    }
  }
`;
