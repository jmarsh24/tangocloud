import { gql } from "@apollo/client";

export const CHECK_LIKE_STATUS_ON_RECORDING = gql`
  query CheckLikeStatusOnRecording($recordingId: ID!) {
    checkLikeStatusOnRecording(recordingId: $recordingId)
  }
`;
