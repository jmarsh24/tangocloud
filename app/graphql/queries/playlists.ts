import { gql } from "@apollo/client";

export const PLAYLISTS = gql`
  query playlists($query: String) {
    playlists(query: $query) {
      edges {
        node {
          id
          title
          playlistAudioTransfers {
            edges {
              node {
                id
                audioTransfer {
                  id
                  audioVariants {
                    edges {
                      node {
                        id
                        audioFile {
                          url
                        }
                      }
                    }
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
