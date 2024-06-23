require "rails_helper"

RSpec.describe "Recordings", type: :graph do
  describe "Querying for recordings" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query Recordings($query: String) {
          recordings(query: $query) {
            edges {
              node {
                id
                title
                recordedDate
                audioTransfers {
                  edges {
                    node {
                      album {
                        albumArtUrl
                      }
                      audioVariants {
                        edges {
                          node {
                            id
                            duration
                            audioFileUrl
                          }
                        }
                      }
                    }
                  }
                }
                orchestra {
                  name
                }
                singers {
                  edges {
                    node {
                      name
                    }
                  }
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
      debugger
      found_recording = data.recordings.edges.first.node

      expect(found_recording.id).to eq(recording.id.to_s)
      expect(found_recording.title).to eq("Volver a soñar")
      expect(found_recording.recorded_date).to eq(recording.recorded_date.iso8601)
      expect(found_recording.orchestra.name).to eq("Carlos Di Sarli")
      expect(found_recording.singers.edges.first.node.name).to eq("Roberto Rufino")
      expect(found_recording.genre.name).to eq("Tango")
      expect(found_recording.audio_transfers.edges).not_to be_empty
      expect(found_recording.audio_transfers.edges.first.node.album.album_art_url).not_to be_nil
    end
  end
end
