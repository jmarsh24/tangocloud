require "rails_helper"

RSpec.describe "Playlist Query" do
  describe "Fetching playlist details" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant) }

    let(:query) do
      <<~GQL
        query playlist($id: ID!) {
          playlist(id: $id) {
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
      GQL
    end

    it "returns the correct playlist details, including audio transfers and variants" do
      result = TangocloudSchema.execute(query, variables: {id: playlist.id.to_s}, context: {current_user: user})

      playlist_data = result.dig("data", "playlist")

      expect(playlist_data["title"]).to eq(playlist.title)
      expect(playlist_data["id"]).to eq(playlist.id.to_s)
      first_playlist_audio_transfer_data = playlist_data["playlistAudioTransfers"].first
      expect(first_playlist_audio_transfer_data).not_to be_nil

      first_audio_transfer_data = first_playlist_audio_transfer_data["audioTransfer"]
      expect(first_audio_transfer_data).not_to be_nil

      first_audio_variant_data = first_audio_transfer_data["audioVariants"].first
      expect(first_audio_variant_data["id"]).to eq(audio_variant.id.to_s)
      expect(first_audio_variant_data["audioFileUrl"]).to be_present
    end
  end
end
