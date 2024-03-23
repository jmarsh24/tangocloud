import { gql } from "@apollo/client";

export const FETCH_RECORDING_URL = gql`
  query FetchRecording($id: ID!) {
    fetchRecording(id: $id) {
      audioTransfers {
        audioVariants {
          audioFileUrl
        }
      }
    }
  }
`;

export default FETCH_RECORDING_URL;
