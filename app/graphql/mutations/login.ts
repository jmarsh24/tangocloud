import { gql } from "@apollo/client";

export const LOGIN = gql`
  mutation login($login: String!, $password: String!) {
    login(input: { login: $login, password: $password }) {
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
