import { gql } from '@apollo/client';

export const CURRENT_USER = gql`
  query currentUser {
    currentUser {
      id
      email
      username
      avatar {
        url
      }
    }
  }
`;
