import { gql } from "@apollo/client";

export const SEARCH_RECORDINGS = gql`
  query SearchRecordings($query: String, $first: Int, $after: String) {
    searchRecordings(query: $query, first: $first, after: $after) {
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
