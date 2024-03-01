import { gql } from "@apollo/client";

export const RECORDING = gql`
  query recording($Id: ID!) {
    recording(id: $Id) {
      id
      title
      singers {
        name
      }
      orchestra {
        name
      }
      genre {
        name
      }
      audioTransfers {
        album {
          albumArt {
            url
          }
        }
        waveform {
          data
        }
      }
      audioVariants {
        id
        bitRate
        codec
        duration
        format
        audioFile {
          url
        }
      }
      recordedDate
    }
  }
`;
