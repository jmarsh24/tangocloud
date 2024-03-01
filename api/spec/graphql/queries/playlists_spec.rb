require "rails_helper"

RSpec.describe "Playlists Query" do
  describe "Fetching playlists" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant) }

    let(:query) do
      <<~GQL
        query playlists($query: String) {
          playlists(query: $query) {
            edges {
              node {
                id
                title
                playlistAudioTransfers {
                  id
                  audioTransfer {
                    id
                    audioVariants {
                      id
                      audioFileUrl
                    }
                  }
                }
              }
            }
          }
        }
      GQL
    end

    it "returns the correct playlist details, including audio transfers and variants" do
      result = TangocloudSchema.execute(query, variables: {query: "awesome"}, context: {current_user: user})

      playlists_data = result.dig("data", "playlists", "edges")
      expect(playlists_data).not_to be_empty

      first_playlist_data = playlists_data.first.dig("node")

      expect(first_playlist_data["title"]).to eq(playlist.title)
      expect(first_playlist_data["id"]).to eq(playlist.id.to_s)

      first_audio_transfer_data = first_playlist_data["playlistAudioTransfers"].first
      expect(first_audio_transfer_data).not_to be_nil
      expect(first_audio_transfer_data["audioTransfer"]["id"]).to eq(audio_transfer.id.to_s)

      first_audio_variant_data = first_audio_transfer_data["audioTransfer"]["audioVariants"].first
      expect(first_audio_variant_data["id"]).to eq(audio_variant.id.to_s)

      expect(first_audio_variant_data["audioFileUrl"]).to be_present
    end
  end
end
