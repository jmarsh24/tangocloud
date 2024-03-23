import { gql } from "@apollo/client";

export const FETCH_SINGER = gql`
  query FetchSinger($id: ID!) {
    fetchSinger(id: $id) {
      id
      name
      photoUrl
      recordings {
        edges {
          node {
            id
            title
            year
            genre {
              name
            }
            orchestra {
              name
            }
            singers {
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
