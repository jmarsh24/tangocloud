require "rails_helper"

RSpec.describe "recordings", type: :graph do
  describe "Querying for recordings" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query SearchRecordings($query: String) {
          searchRecordings(query: $query) {
            edges {
              node {
                id
                title
                recordedDate
                audioTransfers {
                  album {
                    albumArtUrl
                  }
                  audioVariants {
                    id
                    duration
                    audioFileUrl
                  }
                }
                orchestra {
                  name
                }
                singers {
                  name
                }
                genre {
                  name
                }
              }
            }
          }
        }
      GQL
    end

    it "returns comprehensive details for recordings including orchestra and singers" do
      gql(query, variables: {query: "Volver a sonar"}, user:)

      found_recording = data.search_recordings.edges.first.node

      expect(found_recording.id).to eq(recording.id.to_s)
      expect(found_recording.title).to eq("Volver a soñar")
      expect(found_recording.recorded_date).to eq(recording.recorded_date.iso8601)
      expect(found_recording.orchestra.name).to eq("Carlos DI SARLI")
      expect(found_recording.singers.first.name).to eq("Roberto Rufino")
      expect(found_recording.genre.name).to eq("tango")
      expect(found_recording.audio_transfers.first.album.album_art_url).not_to be_nil
      expect(found_recording.audio_transfers.first.album.album_art_url).not_to be_empty
    end
  end
end
