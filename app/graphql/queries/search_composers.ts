import { gql } from "@apollo/client";

export const SEARCH_COMPOSERS = gql`
  query SearchComposers($query: String) {
    searchComposers(query: $query) {
      edges {
        node {
          id
          name
        }
      }
    }
  }
`;
