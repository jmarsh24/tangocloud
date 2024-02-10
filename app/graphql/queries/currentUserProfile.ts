import { gql } from "@apollo/client";

export const CURRENT_USER_PROFILE = gql`
  query CurrentUserProfile {
    currentUserProfile {
      id
      email
      username
      name
      firstName
      lastName
      verified
      admin
      createdAt
      updatedAt
    }
  }
`;
