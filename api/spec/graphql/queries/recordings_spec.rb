require "rails_helper"

RSpec.describe "Recordings", type: :graph do
  describe "Querying for recordings" do
    let!(:user) { create(:user) }
    let!(:singer) { create(:singer, name: "Roberto Rufino") }
    let!(:genre) { create(:genre, name: "Tango") }
    let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
    let!(:recording) { create(:recording, title: "Volver a soñar", singers: [singer], orchestra:, genre:) }
    let!(:audio_transfer) { create(:audio_transfer, recording:) }

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
                        albumArt {
                          blob {
                            url
                          }
                        }
                      }
                      audioVariants {
                        edges {
                          node {
                            id
                            duration
                            audioFile {
                              blob {
                                url
                              }
                            }
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
      Recording.reindex

      gql(query, variables: {query: "Volver a sonar"}, user:)

      found_recording = data.recordings.edges.first.node

      expect(found_recording.id).to eq(recording.id.to_s)
      expect(found_recording.title).to eq("Volver a soñar")
      expect(found_recording.recorded_date).to eq(recording.recorded_date.iso8601)
      expect(found_recording.orchestra.name).to eq("Carlos Di Sarli")
      expect(found_recording.singers.edges.first.node.name).to eq("Roberto Rufino")
      expect(found_recording.genre.name).to eq("Tango")
      expect(found_recording.audio_transfers.edges).not_to be_empty
      expect(found_recording.audio_transfers.edges.first.node.album.album_art.blob.url).not_to be_nil
    end
  end
end
