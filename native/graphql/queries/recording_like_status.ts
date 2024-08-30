import { gql } from '@apollo/client'

export const RECORDING_LIKE_STATUS = gql`
  query RecordingLikeStatus($recordingId: ID!) {
    recording(id: $recordingId) {
      id
      likedByCurrentUser
    }
  }
`;
