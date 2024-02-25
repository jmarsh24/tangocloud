import { gql } from "@apollo/client";

export const RECORDING = gql`
  query recording($Id: ID!) {
    recording(id: $Id) {
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
          data
        }
      }
      audioVariants {
        id
        audioFileUrl
        bitRate
        codec
        duration
        format
      }
      recordedDate
    }
  }
`;
