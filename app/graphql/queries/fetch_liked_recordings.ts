import { gql } from "@apollo/client";

export const FETCH_LIKED_RECORDINGS = gql`
  query FetchLikedRecordings {
    fetchLikedRecordings {
      edges {
        node {
          id
          title
          genre {
            id
            name
          }
          orchestra {
            id
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
