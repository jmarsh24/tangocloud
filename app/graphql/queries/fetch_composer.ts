import { gql } from "@apollo/client";

export const FETCH_COMPOSER = gql`
  query fetchComposer($id: ID!) {
    fetchComposer(id: $id) {
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
