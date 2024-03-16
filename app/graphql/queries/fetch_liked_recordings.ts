import { gql } from "@apollo/client";

export const FETCH_LIKED_RECORDINGS = gql`
  query FetchLikedRecordings {
    fetchLikedRecordings {
      edges {
        node {
          id
          title
          year
          genre {
            name
          }
          singers {
            name
          }
          orchestra {
            name
          }
          audioTransfers {
            id
            album {
              id
              albumArtUrl
            }
            audioVariants {
              id
              audioFileUrl
              duration
            }
          }
        }
      }
    }
  }
`;
