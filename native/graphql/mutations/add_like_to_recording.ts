import { gql } from "@apollo/client";

export const ADD_LIKE_TO_RECORDING = gql`
  mutation AddLikeToRecording($recordingId: ID!) {
    addLikeToRecording(input: { recordingId: $recordingId }) {
      like {
        id
        likeableType
        likeableId
        user {
          id
        }
      }
      success
      errors
    }
  }
`;

export default ADD_LIKE_TO_RECORDING;
