import { gql } from '@apollo/client';

export const LIKED_RECORDINGS = gql`

query likedRecordings {
  currentUser {
    likedRecordings {
      edges {
        node {
          id
          composition {
            title
          }
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
