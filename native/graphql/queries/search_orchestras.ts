import { gql } from '@apollo/client'

export const SEARCH_ORCHESTRAS = gql`
  query orchestras($query: String) {
    orchestras(query: $query) {
      edges {
        node {
          id
          name
          image {
            url
          }
        }
      }
    }
  }
`
