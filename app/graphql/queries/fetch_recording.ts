import { gql } from "@apollo/client";

export const FETCH_RECORDING = gql`
  query FetchRecording($id: ID!) {
    fetchRecording(id: $id) {
      id
      title
      genre {
        name
      }
      year
      singers {
        name
        slug
      }
      composition {
        composer {
          name
          slug
        }
        lyricist {
          name
          slug
        }
        lyrics {
          locale
          content
        }
      }
      audioTransfers {
        album {
          albumArtUrl
        }
        audioVariants {
          audioFileUrl
          duration
        }
        waveform {
          data
        }
      }
      orchestra {
        name
        slug
        photoUrl
      }
    }
  }
`;
