import { gql } from "@apollo/client";

export const REMOVE_LIKE_FROM_RECORDING = gql`
  mutation RemoveLikeFromRecording($recordingId: ID!) {
    removeLikeFromRecording(input: { recordingId: $recordingId }) {
      success
      errors
    }
  }
`;

export default REMOVE_LIKE_FROM_RECORDING;
