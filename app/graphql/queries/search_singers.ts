import { gql } from "@apollo/client";

export const SEARCH_SINGERS = gql`
  query SearchSingers($query: String) {
    searchSingers(query: $query) {
      edges {
        node {
          id
          name
        }
      }
    }
  }
`;
