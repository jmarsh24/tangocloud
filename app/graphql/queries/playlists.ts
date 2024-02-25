import { gql } from "@apollo/client";

export const PLAYLISTS = gql`
  query Playlists(query, String, $first: Int, $after: String) {
    playlists(query: $query, first: $first, after: $after) {
      edges {
        node {
          id
          title
          public
          imageUrl
        }
      }
      pageInfo {
        endCursor
        startCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
`;
