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
