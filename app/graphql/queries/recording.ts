import { gql } from "@apollo/client";

export const RECORDING = gql`
  query recording($id: ID!) {
    recording(id: $id) {
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
