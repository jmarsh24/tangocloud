import { gql } from "@apollo/client";

export const FETCH_RECORDING = gql`
  query FetchRecording($id: ID!) {
    fetchRecording(id: $id) {
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
