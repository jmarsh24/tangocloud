import { gql } from "@apollo/client";

export const FETCH_ORCHESTRA = gql`
  query FetchOrchestra($id: ID!) {
    fetchOrchestra(id: $id) {
      id
      name
      photoUrl
      recordings {
        edges {
          node {
            id
            title
            recordedDate
            genre {
              name
            }
            audioTransfers {
              album {
                albumArtUrl
              }
              audioVariants {
                audioFileUrl
              }
            }
          }
        }
      }
    }
  }
`;
