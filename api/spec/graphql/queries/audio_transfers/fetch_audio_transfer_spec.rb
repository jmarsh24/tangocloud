require "rails_helper"

RSpec.describe "fetchAudioTransfer" do
  describe "Querying for audio transfer" do
    let!(:user) { users(:admin) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer) }
    let(:query) do
      <<~GQL
        query FetchAudioTransfer($id: ID!) {
          fetchAudioTransfer(id: $id) {
            id
            album {
              albumArtUrl
            }
            audioVariants {
              id
              duration
              audioFileUrl
            }
          }
        }
      GQL
    end

    it "returns comprehensive details for audio transfer including album and audio variants" do
      result = TangocloudSchema.execute(query, variables: {id: audio_transfer.id}, context: {current_user: user})

      audio_transfer_data = result.dig("data", "fetchAudioTransfer")
      expect(audio_transfer_data).not_to be_nil
      expect(audio_transfer_data["id"]).to eq(audio_transfer.id.to_s)
      expect(audio_transfer_data["album"]["albumArtUrl"]).not_to be_nil
      expect(audio_transfer_data["audioVariants"].first["audioFileUrl"]).not_to be_empty
    end
  end
end
