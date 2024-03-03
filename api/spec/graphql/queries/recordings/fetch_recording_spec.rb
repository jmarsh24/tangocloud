require "rails_helper"

RSpec.describe "Fetch Recording", type: :graph do
  describe "Querying for recording" do
    let!(:user) { users(:admin) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let(:query) do
      <<~GQL
        query FetchRecording($id: ID!) {
          fetchRecording(id: $id) {
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
                albumArtUrl
              }
              waveform {
                imageUrl
                data
              }
            }
          }
        }
      GQL
    end

    it "returns the correct recording details" do
      gql(query, variables: {id: recording.id.to_s}, user:)
      recording_data = data.fetch_recording

      expect(recording_data.id).to eq(recording.id.to_s)
      expect(recording_data.title).to eq("Volver a sonar")
      expect(recording_data.singers.first.name).to eq("Roberto Rufino")
      expect(recording_data.orchestra.name).to eq("Carlos Di Sarli")
      expect(recording_data.genre.name).to eq("tango")

      expect(recording_data.audio_transfers).not_to be_empty
      audio_transfer = recording_data.audio_transfers.first
      expect(audio_transfer.album.album_art_url).not_to be_nil
      expect(audio_transfer.waveform.image_url).not_to be_nil
      expect(audio_transfer.waveform.data).not_to be_empty
    end
  end
end
