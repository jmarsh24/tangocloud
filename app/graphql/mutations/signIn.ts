import { gql } from "@apollo/client";

export const LOGIN_MUTATION = gql`
  mutation SignIn($login: String!, $password: String!) {
    signIn(input: { login: $login, password: $password }) {
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
