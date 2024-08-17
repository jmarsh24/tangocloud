import { gql } from '@apollo/client'

export const ORCHESTRA = gql`
  query Orchestra($id: ID!) {
    orchestra(id: $id) {
      id
      name
      image {
        blob {
          url
        }
      }
      recordings {
        edges {
          node {
            id
            genre {
              name
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
          }
        }
      }
    }
  }
`
