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
      }
      composition {
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
      }
    }
  }
`;
