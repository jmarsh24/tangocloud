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
      result = TangocloudSchema.execute(query, variables: {id: playlist.id}, context: {current_user: user})

      playlist_data = result.dig("data", "playlist")
      first_audio_transfer_data = playlist_data["playlistAudioTransfers"].first["audioTransfer"]
      first_audio_variant_data = first_audio_transfer_data["audioVariants"].first

      expect(playlist_data["title"]).to eq(playlist.title), "Expected playlist title to match"
      expect(playlist_data["id"]).to eq(playlist.id.to_s), "Expected playlist ID to match"

      expect(playlist_data["playlistAudioTransfers"].count).to eq(playlist.playlist_audio_transfers.count), "Expected number of playlist audio transfers to match"

      expect(first_audio_variant_data["id"]).to eq(audio_variant.id), "Expected audio variant ID to match"
      expect(first_audio_variant_data["audioFileUrl"]).to eq(Rails.application.routes.url_helpers.rails_blob_url(audio_variant.audio_file)), "Expected audio file URL to match"
    end
  end
end
