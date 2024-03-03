require "rails_helper"

RSpec.describe "Search Playlists", type: :graph do
  describe "Fetching playlists" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:audio_transfer) { audio_transfers(:volver_a_sonar_tango_tunes_1940_audio_transfer) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_tango_tunes_1940_audio_variant) }

    let(:query) do
      <<~GQL
        query searchPlaylists($query: String!) {
          searchPlaylists(query: $query) {
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
      gql(query, variables: {query: "Awesome"}, user:)

      expect(gql_errors).to be_empty

      playlists_data = data.search_playlists.edges
      expect(playlists_data).not_to be_empty

      first_playlist = playlists_data.first.node
      expect(first_playlist.title).to eq("Awesome Playlist")
      expect(first_playlist.id).to eq(playlist.id.to_s)

      playlist_audio_transfers = first_playlist.playlist_audio_transfers
      expect(playlist_audio_transfers).not_to be_empty

      first_audio_transfer_data = playlist_audio_transfers.first.audio_transfer
      expect(first_audio_transfer_data.id).to eq(audio_transfer.id.to_s)

      audio_variant_data = first_audio_transfer_data.audio_variants.first
      expect(audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(audio_variant_data.audio_file_url).to be_present
    end
  end
end
