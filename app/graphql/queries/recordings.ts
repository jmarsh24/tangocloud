import { gql } from "@apollo/client";

export const RECORDINGS = gql`
  query Recordings($query: String, $first: Int, $after: String) {
    recordings(query: $query, first: $first, after: $after) {
      edges {
        node {
          id
          title
          recordedDate
          audioTransfers {
            album {
              albumArt {
                url
              }
            }
            audioVariants {
              id
            duration
            audioFile {
              url
            }
          }
          orchestra {
            name
          }
          singers {
            name
          }
          genre {
            name
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
  }
`;
