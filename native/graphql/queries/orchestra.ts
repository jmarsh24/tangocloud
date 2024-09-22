import { gql } from "@apollo/client";

export const ORCHESTRA = gql`
  query Orchestra($id: ID!) {
    orchestra(id: $id) {
      id
      name
      image {
        url
      }
      recordings {
        edges {
          node {
            id
            composition {
              title
            }
            genre {
              name
            }
            year
            singers {
              edges {
                node {
                  name
                }
              }
            }
            digitalRemasters {
              edges {
                node {
                duration
                  audioVariants {
                    edges {
                      node {
                        audioFile {
                          url
                        }
                      }
                    }
                  }
                  album {
                    albumArt {
                      url
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
