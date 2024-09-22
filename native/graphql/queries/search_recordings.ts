import { gql } from '@apollo/client'

export const SEARCH_RECORDINGS = gql`
	query searchRecordings(
		$query: String
		$filters: RecordingFilterInput
		$order_by: RecordingOrderByInput
		$aggs: [RecordingAggregationInput!],
    $limit: Int,
    $offset: Int
	) {
		searchRecordings(query: $query, filters: $filters, orderBy: $order_by, aggs: $aggs, limit: $limit, offset: $offset) {
			recordings {
				edges {
					node {
						id
            composition {
              title
            }
            year
            genre {
              name
            }
            digitalRemasters {
              edges {
                node {
                  duration
                  album {
                    albumArt {
                      url
                    }
                  }
                }
              }
            }
            orchestra {
              name
            }
            recordingSingers {
              edges {
                node {
                  person {
                    name
                  }
                  soloist
                }
              }
            }
					}
				}
			}
			aggregations {
        orchestra {
          key
          docCount
        }
				orchestraPeriods {
					key
					docCount
				}
				timePeriod {
					key
					docCount
				}
				singers {
					key
					docCount
				}
				genre {
					key
					docCount
				}
        year {
          key
          docCount
        }
			}
		}
	}
`
