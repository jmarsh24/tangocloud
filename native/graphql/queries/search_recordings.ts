import { gql } from '@apollo/client'

export const SEARCH_RECORDINGS = gql`
  query searchRecordings($query: String, $filters: RecordingFilterInput, $order_by: RecordingOrderByInput) {
    searchRecordings(query: $query, filters: $filters, orderBy: $order_by) {
      recordings {
        edges {
          node {
            id
            composition {
              title
            }
            year
            genre {
              name
            }
            digitalRemasters {
              edges {
                node {
                  duration
                  album {
                    albumArt {
                      blob {
                        url
                      }
                    }
                  }
                }
              }
            }
            orchestra {
              name
            }
            recordingSingers {
              edges {
                node {
                  person {
                    name
                  }
                  soloist
                }
              }
            }
          }
        }
      }
    }
  }
`
