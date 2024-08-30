import { gql } from '@apollo/client'

export const LIKE_RECORDING = gql`
	mutation LikeRecording($recordingId: ID!) {
		likeRecording(input: { recordingId: $recordingId }) {
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
`
