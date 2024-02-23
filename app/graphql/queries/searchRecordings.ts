import { gql } from "@apollo/client";

export const SEARCH_RECORDINGS = gql`
  query SearchRecordings($query: String!, $first: Int, $after: String) {
    searchRecordings(query: $query, first: $first, after: $after) {
      edges {
        node {
          id
          title
          audioTransfers {
            album {
              albumArtUrl
            }
          }
          audioVariants {
            id
            duration
            url
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
          recordedDate
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
