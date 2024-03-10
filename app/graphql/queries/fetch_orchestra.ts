import { gql } from "@apollo/client";

export const FETCH_ORCHESTRA = gql`
  query FetchOrchestra($id: ID!) {
    fetchOrchestra(id: $id) {
      id
      name
      recordings {
        edges {
          node {
            id
            title
            audioTransfers {
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
