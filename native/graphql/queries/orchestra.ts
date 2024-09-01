import { gql } from "@apollo/client";

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
                          blob {
                            url
                          }
                        }
                      }
                    }
                  }
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
          }
        }
      }
    }
  }
`
