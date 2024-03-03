require "rails_helper"

RSpec.describe "Fetch Playlist", type: :graph do
  describe "Fetching playlist details" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant) }

    let(:query) do
      <<~GQL
        query FetchPlaylist($id: ID!) {
          fetchPlaylist(id: $id) {
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
      gql(query, variables: {id: playlist.id.to_s}, user:)

      playlist_data = data.fetch_playlist

      expect(playlist_data.title).to eq(playlist.title)
      expect(playlist_data.id).to eq(playlist.id.to_s)
      first_playlist_audio_transfer_data = playlist_data.playlist_audio_transfers.first
      expect(first_playlist_audio_transfer_data).not_to be_nil

      first_audio_transfer_data = first_playlist_audio_transfer_data.audio_transfer
      expect(first_audio_transfer_data).not_to be_nil

      first_audio_variant_data = first_audio_transfer_data.audio_variants.first
      expect(first_audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(first_audio_variant_data.audio_file_url).to be_present
    end
  end
end
