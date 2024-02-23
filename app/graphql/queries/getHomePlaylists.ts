import { gql } from "@apollo/client";

export const GET_HOME_PLAYLISTS = gql`
  query GetHomePlaylists($first: Int, $after: String) {
    getHomePlaylists(first: $first, after: $after) {
      edges {
        node {
          id
          title
          description
          public
          imageUrl
          songsCount
          likesCount
          listensCount
          sharesCount
          followersCount
          user {
            id
            username
            avatarUrl
          }
          playlistAudioTransfers {
            id
            audioTransfer {
              id
              album {
                albumArtUrl
              }
              audioVariants {
                audioFileUrl
                duration
              }
              recording {
                title
                orchestra {
                  name
                }
              }
            }
          }
          createdAt
          updatedAt
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
`;
