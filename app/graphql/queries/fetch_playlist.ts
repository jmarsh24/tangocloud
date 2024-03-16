import { gql } from "@apollo/client";

export const FETCH_PLAYLIST = gql`
  query FetchPlaylist($id: ID!) {
    fetchPlaylist(id: $id) {
      id
      title
      playlistItems {
        id
        playable {
          ... on Recording {
            id
            title
            year
            genre {
              name
            }
            orchestra {
              name
            }
            audioTransfers {
              id
              audioVariants {
                audioFileUrl
                duration
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
