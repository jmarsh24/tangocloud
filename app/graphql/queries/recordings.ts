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
            edges {
              node {
                album {
                  albumArt {
                    url
                  }
                }
                audioVariants {
                  edges {
                    node {
                      id
                      duration
                      audioFile {
                        url
                      }
                    }
                  }
                }
              }
            }
          }
          orchestra {
            name
          }
          singers {
            edges {
              node {
                name
              }
            }
          }
          genre {
            name
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
