import { gql } from "@apollo/client";

export const RECORDINGS = gql`
  query Recordings($query: String, $first: Int, $after: String) {
    recordings(query: $query, first: $first, after: $after) {
      edges {
        node {
          id
          title
          recordedDate
          orchestra {
            name
          }
          singers {
            name
          }
          genre {
            name
          }
          audioTransfers {
            album {
              albumArtUrl
            }
            audioVariants {
              id
              duration
              audioFileUrl
            }
          }
        }
      }
      pageInfo {
        endCursor
        startCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
`;
