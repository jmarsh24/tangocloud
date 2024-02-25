import { gql } from "@apollo/client";

export const GET_HOME_PLAYLISTS = gql`
  query GetHomePlaylists($first: Int, $after: String) {
    getHomePlaylists(first: $first, after: $after) {
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
