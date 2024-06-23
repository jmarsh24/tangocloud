require "rails_helper"

RSpec.describe "audioTransfer", type: :graph do
  describe "audioTransfer" do
    let!(:user) { users(:admin) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
    let(:query) do
      <<~GQL
        query AudioTransfer($id: ID!) {
          audioTransfer(id: $id) {
            id
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
      GQL
    end

    it "returns comprehensive details for audio transfer including album and audio variants" do
      gql(query, variables: {id: audio_transfer.id.to_s}, user:)

      expect(data.audio_transfer).not_to be_nil
      expect(data.audio_transfer.id).to eq(audio_transfer.id.to_s)
      expect(data.audio_transfer.album.album_art_url).not_to be_nil
      expect(data.audio_transfer.audio_variants.edges).not_to be_empty
      expect(data.audio_transfer.audio_variants.edges.first.node.id).to eq(audio_transfer.audio_variants.first.id.to_s)
    end
  end
end
