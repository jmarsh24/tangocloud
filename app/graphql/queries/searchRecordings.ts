import { gql } from "@apollo/client";

export const SEARCH_RECORDINGS = gql`
  query MyQuery($query: String!) {
    searchRecordings(query: $query) {
      title
      orchestra {
        name
      }
      singers {
        name
      }
      audios {
        url
      }
      albumArtUrl
      recordedDate
      genre {
        name
      }
    }
  }
`;
