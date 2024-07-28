import { gql } from '@apollo/client'

export const CURRENT_USER = gql`
  query CurrentUser {
    currentUser {
      id
      email
      username
      admin
      createdAt
      updatedAt
      playbacks {
        edges {
          node {
            id
            recording {
              id
              like
              orchestra {
                name
              }
              genre {
                name
              }
              singers {
                edges {
                  node {
                    name
                  }
                }
              }
              composition {
                lyrics {
                  edges {
                    node {
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
`
