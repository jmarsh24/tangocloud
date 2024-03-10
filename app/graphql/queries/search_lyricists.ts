import { gql } from "@apollo/client";

export const SEARCH_LYRICISTS = gql`
  query searchLyricists($query: String) {
    searchLyricists(query: $query) {
      edges {
        node {
          id
          name
        }
      }
    }
  }
`;
