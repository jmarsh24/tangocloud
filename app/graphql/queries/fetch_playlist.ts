import { gql } from "@apollo/client";

export const FETCH_PLAYLIST = gql`
  query FetchPlaylist($id: ID!) {
    fetchPlaylist(id: $id) {
      id
      title
      orchestra {
        name
      }
      playlistItems {
        id
        playable {
          ... on Recording {
            id
            title
            audioTransfers {
              id
              audioVariants {
                audioFileUrl
                duration
                audioVariants {
                  id
                  audioFileUrl
                }
              }
              album {
                albumArtUrl
              }
            }
          }
        }
      }
    }
  }
`;
