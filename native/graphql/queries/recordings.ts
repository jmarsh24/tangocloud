import { gql } from '@apollo/client'

export const RECORDINGS = gql`
  query Recordings($first: Int, $after: String) {
    recordings(first: $first, after: $after) {
      edges {
        node {
          id
          recordedDate
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
          composition {
            lyrics {
              edges {
                node {
									id
									text
									language {
										name
									}
                }
              }
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
`
