import { gql } from '@apollo/client'

export const UNLIKE_RECORDING = gql`
	mutation UnlikeRecording($recordingId: ID!) {
		unlikeRecording(input: { recordingId: $recordingId }) {
			success
			errors
		}
	}
`
