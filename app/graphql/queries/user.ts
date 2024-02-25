import { gql } from "@apollo/client";

export const user = gql`
  query User {
    user {
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
