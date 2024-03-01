import { gql } from "@apollo/client";

export const PLAYLISTS = gql`
  query playlists($query: String) {
    playlists(query: $query) {
      edges {
        node {
          id
          title
          imageUrl
          playlistAudioTransfers {
            id
            audioTransfer {
              id
              audioVariants {
                id
                audioFileUrl
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
