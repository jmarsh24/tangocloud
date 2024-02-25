import { gql } from "@apollo/client";

export const RECORDING = gql`
  query recording($recordingId: ID!) {
    recording(id: $recordingId) {
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
