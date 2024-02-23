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
      album {
        albumArtUrl
      }
      audioVariants {
        id
        url
        bitRate
        codec
        duration
        format
      }
      recordedDate
      waveforms {
        length
        data
      }
    }
  }
`;
