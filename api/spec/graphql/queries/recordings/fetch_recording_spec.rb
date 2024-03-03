require "rails_helper"

RSpec.describe "recording" do
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
      result = TangocloudSchema.execute(query, variables: {id: recording.id.to_s}, context: {current_user: user})
      recording_data = result.dig("data", "fetchRecording")

      expect(recording_data["id"]).to eq(recording.id.to_s)
      expect(recording_data["title"]).to eq("Volver a sonar")
      expect(recording_data["singers"][0]["name"]).to eq("Roberto Rufino")
      expect(recording_data["orchestra"]["name"]).to eq("Carlos Di Sarli")
      expect(recording_data["genre"]["name"]).to eq("tango")

      expect(recording_data["audioTransfers"]).not_to be_empty
      audio_transfer = recording_data["audioTransfers"][0]
      expect(audio_transfer["album"]["albumArtUrl"]).not_to be_nil
      expect(audio_transfer["waveform"]["imageUrl"]).not_to be_nil
      expect(audio_transfer["waveform"]["data"]).not_to be_empty
    end
  end
end
