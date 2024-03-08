import { gql } from "@apollo/client";

export const FETCH_RECORDING = gql`
  query SearchRecording($id: ID!) {
    searchRecording(id: $id) {
      id
      title
      singers {
        name
      }
      orchestra {
        name
      }
      genre {
        name
      }
      audioTransfers {
        album {
          albumArtUrl
        }
        waveform {
          imageUrl
          data
        }
        audioVariants {
          id
          duration
          audioFileUrl
        }
      }
    }
  }
`;
