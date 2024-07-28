import { gql } from '@apollo/client'

export const TANDA_OF_THE_WEEK = gql`
  query TandaOfTheWeek($query: String, $first: Int) {
    playlists(query: $query, first: $first) {
      edges {
        node {
          id
          description
          image {
						url
					}
          playlistItems {
            edges {
              node {
                id
                item {
                  ... on Recording {
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
