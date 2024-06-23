require "rails_helper"

RSpec.describe "Recording", type: :graph do
  describe "Querying for recording" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query Recording($id: ID!) {
          recording(id: $id) {
            id
            title
            singers {
              edges {
                node {
                  name
                }
              }
            }
            orchestra {
              name
            }
            genre {
              name
            }
            audioTransfers {
              edges {
                node {
                  album {
                    albumArtUrl
                  }
                  waveform {
                    imageUrl
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
      gql(query, variables: {id: recording.id.to_s}, user:)
      recording_data = data.recording

      expect(recording_data.id).to eq(recording.id.to_s)
      expect(recording_data.title).to eq("Volver a soñar")
      expect(recording_data.singers.edges.first.node.name).to eq("Roberto Rufino")
      expect(recording_data.orchestra.name).to eq("Carlos Di Sarli")
      expect(recording_data.genre.name).to eq("Tango")

      expect(recording_data.audio_transfers.edges).not_to be_empty
      audio_transfer = recording_data.audio_transfers.edges.first.node
      expect(audio_transfer.album.album_art_url).not_to be_nil
      expect(audio_transfer.waveform.image_url).not_to be_nil
      expect(audio_transfer.waveform.data).not_to be_empty
    end
  end
end
