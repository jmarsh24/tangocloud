require "rails_helper"

RSpec.describe "fetchAudioTransfer", type: :graph do
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
      gql(query, variables: {id: audio_transfer.id.to_s}, user:)

      expect(data.fetch_audio_transfer).not_to be_nil
      expect(data.fetch_audio_transfer.id).to eq(audio_transfer.id.to_s)
      expect(data.fetch_audio_transfer.album.album_art_url).not_to be_nil
      expect(data.fetch_audio_transfer.audio_variants.first.audio_file_url).not_to be_empty
    end
  end
end
