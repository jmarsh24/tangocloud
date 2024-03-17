import { gql } from "@apollo/client";

export const FETCH_SINGER = gql`
  query FetchSinger($id: ID!) {
    fetchSinger(id: $id) {
      id
      name
      recordings {
        edges {
          node {
            id
            title
            photoUrl
            orchestra {
              name
            }
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
`;
