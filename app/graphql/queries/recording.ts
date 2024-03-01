import { gql } from "@apollo/client";

export const RECORDING = gql`
  query recording($id: ID!) {
    recording(id: $id) {
      id
      title
      singers {
        edges {
          node {
            name
          }
        }
      }
      orchestra {
        name
      }
      genre {
        name
      }
      audioTransfers {
        edges {
          node {
            album {
              albumArt {
                url
              }
            }
            waveform {
              image {
                url
              }
              data
            }
          }
        }
      }
    }
  }
`;
