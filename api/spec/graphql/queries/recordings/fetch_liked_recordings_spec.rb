require "rails_helper"

RSpec.describe "fetchLikedRecordings", type: :graph do
  let(:user) { users(:normal) }
  let(:query) do
    <<~GQL
      query {
        fetchLikedRecordings {
          edges {
            node {
              id
              title
              genre {
                id
                name
              }
              orchestra {
                id
                name
              }
              audioTransfers {
                id
                album {
                  id
                  albumArtUrl
                }
                audioVariants {
                  id
                  audioFileUrl
                  duration
                }
              }
            }
          }
        }
      }
    GQL
  end

  describe "fetchLikedRecordings" do
    it "fetches liked recordings" do
      gql(query, user:)

      expect(data.fetch_liked_recordings.edges.size).to eq(1)
    end
  end
end
