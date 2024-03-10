import { gql } from "@apollo/client";

const CREATE_PLAYBACK = gql`
  mutation CreatePlayback($recordingId: String!) {
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
