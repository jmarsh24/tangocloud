import { gql } from "@apollo/client";

export const GET_RECORDING_DETAILS = gql`
  query getRecordingDetails($recordingId: ID!) {
    getRecordingDetails(id: $recordingId) {
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
