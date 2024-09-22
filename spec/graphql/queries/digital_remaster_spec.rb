require "rails_helper"

RSpec.describe "digitalRemaster", type: :graph do
  describe "digitalRemaster" do
    let!(:user) { create(:user, :approved) }
    let!(:audio_file) { create(:audio_file) }
    let!(:orchestra) { create(:orchestra) }
    let!(:genre) { create(:genre) }
    let!(:composition) { create(:composition) }
    let!(:recording) { create(:recording, orchestra:, genre:, composition:) }
    let!(:digital_remaster) { create(:digital_remaster, recording:, audio_file:) }
    let!(:audio_variant) { create(:audio_variant, digital_remaster:) }

    let(:query) do
      <<~GQL
        query DigitalRemaster($id: ID!) {
          digitalRemaster(id: $id) {
            id
            album {
              albumArt {
                url
              }
            }
            audioVariants {
              edges {
                node {
                  id
                  url
                  digitalRemaster {
                    duration
                  }
                }
              }
            }
          }
        }
      GQL
    end

    it "returns comprehensive details for audio transfer including album and audio variants" do
      gql(query, variables: {id: digital_remaster.id.to_s}, user:)

      expect(data.digital_remaster).not_to be_nil
      expect(data.digital_remaster.id).to eq(digital_remaster.id.to_s)
      expect(data.digital_remaster.album.album_art.url).not_to be_nil
      expect(data.digital_remaster.audio_variants.edges).not_to be_empty
      expect(data.digital_remaster.audio_variants.edges.first.node.id).to eq(digital_remaster.audio_variants.first.id.to_s)
    end
  end
end
