import { gql } from "@apollo/client";

export const REGISTER_MUTATION = gql`
  mutation Register($username: String!, $email: String!, $password: String!) {
    register(
      input: { username: $username, email: $email, password: $password }
    ) {
      user {
        id
        username
        email
        name
      }
      token
    }
  }
`;
