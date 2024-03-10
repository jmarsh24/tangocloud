import { gql } from "@apollo/client";

export const FETCH_LYRICIST = gql`
  query fetchLyricist($id: ID!) {
    fetchLyricist(id: $id) {
      id
      name
      compositions {
        edges {
          node {
            id
            title
            recordings {
              edges {
                node {
                  id
                  title
                  audioTransfers {
                    audioVariants {
                      audioFileUrl
                      duration
                    }
                    album {
                      albumArtUrl
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
`;
