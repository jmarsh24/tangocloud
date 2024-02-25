import { gql } from "@apollo/client";

export const USER_PROFILE = gql`
  query UserProfile {
    userProfile {
      id
      email
      username
      name
      firstName
      lastName
      verified
      admin
      avatarUrl
      createdAt
      updatedAt
    }
  }
`;
