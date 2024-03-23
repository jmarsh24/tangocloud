import { gql } from "@apollo/client";

export const FETCH_USER = gql`
  query fetchUser($id: ID!) {
    fetchUser(id: $id) {
      id
      name
      email
      username
      firstName
      lastName
      admin
    }
  }
`;
