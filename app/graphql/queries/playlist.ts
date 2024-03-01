import { gql } from "@apollo/client";

export const PLAYLIST = gql`
  query Playlist($Id: ID!) {
    playlist(id: $Id) {
      id
      title
      playlistAudioTransfers {
        audioTransfer {
          id
          audioVariants {
            audioFileUrl
            duration
          }
          recording {
            title
            orchestra {
              name
            }
          }
          album {
            albumArtUrl
          }
        }
      }
    }
  }
`;
