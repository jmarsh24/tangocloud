import { gql } from "@apollo/client";

export const SEARCH_PLAYLISTS = gql`
  query SearchPlaylists($query: String) {
    searchPlaylists(query: $query) {
      edges {
        node {
          id
          title
          description
          imageUrl
          playlistItems {
            id
            playable {
              ... on Recording {
                id
                title
                audioTransfers {
                  id
                  audioVariants {
                    id
                    audioFileUrl
                  }
                }
              }
            }
          }
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
