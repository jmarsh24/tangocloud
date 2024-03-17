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
            photo_url
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
