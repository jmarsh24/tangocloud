require "rails_helper"

RSpec.describe "Recording", type: :graph do
  describe "Querying for recording" do
    let!(:user) { create(:user, :approved) }
    let!(:singer) { create(:person, name: "Roberto Rufino") }
    let!(:orchestra) { create(:orchestra, name: "Carlos Di Sarli") }
    let!(:genre) { create(:genre, name: "Tango") }
    let!(:composition) { create(:composition, title: "Volver a soñar") }
    let!(:recording) { create(:recording, composition:, singers: [singer], orchestra:, genre:) }
    let!(:digital_remaster) { create(:digital_remaster, recording:) }
    let!(:waveform) { create(:waveform, digital_remaster:) }
    let(:query) do
      <<~GQL
        query Recording($id: ID!) {
          recording(id: $id) {
            id
            composition {
              title
            }
            recordingSingers {
              edges {
                node {
                  person {
                    name
                  }
                }
              }
            }
            orchestra {
              name
            }
            genre {
              name
            }
            digitalRemasters {
              edges {
                node {
                  album {
                    albumArt {
                      blob {
                        url
                      }
                    }
                  }
                  waveform {
                    image {
                      blob {
                        url
                      }
                    }
                    data
                  }
                }
              }
            }
          }
        }
      GQL
    end

    it "returns the correct recording details" do
      Recording.reindex
      gql(query, variables: {id: recording.id.to_s}, user:)
      recording_data = data.recording

      expect(recording_data.id).to eq(recording.id.to_s)
      expect(recording_data.composition.title).to eq("Volver a soñar")
      expect(recording_data.recording_singers.edges.first.node.person.name).to eq("Roberto Rufino")
      expect(recording_data.orchestra.name).to eq("Carlos Di Sarli")
      expect(recording_data.genre.name).to eq("Tango")

      expect(recording_data.digital_remasters.edges).not_to be_empty
      digital_remaster = recording_data.digital_remasters.edges.first.node
      expect(digital_remaster.album.album_art.blob.url).not_to be_nil
      expect(digital_remaster.waveform.image.blob.url).not_to be_nil
      expect(digital_remaster.waveform.data).not_to be_empty
    end
  end
end
