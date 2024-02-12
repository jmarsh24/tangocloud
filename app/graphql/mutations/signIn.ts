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
      errors {
        fullMessages
      }
      token
    }
  }
`;
