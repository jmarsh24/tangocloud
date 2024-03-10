import { gql } from "@apollo/client";

export const CREATE_PLAYBACK = gql`
  mutation CreatePlayback($recordingId: ID!) {
    createPlayback(input: { recordingId: $recordingId }) {
      playback {
        id
        recording {
          id
        }
      }
    }
  }
`;
