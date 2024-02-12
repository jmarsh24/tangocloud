import { gql } from "@apollo/client";

export const REGISTER_MUTATION = gql`
  mutation signUp($username: String!, $email: String!, $password: String!) {
    signUp(input: { username: $username, email: $email, password: $password }) {
      user {
        id
        username
        email
        name
      }
      errors {
        fullMessages
      }
      success
    }
  }
`;
