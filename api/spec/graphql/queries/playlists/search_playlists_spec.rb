require "rails_helper"

RSpec.describe "Search Playlists", type: :graph do
  describe "Fetching playlists" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_rufino_aac) }

    let(:query) do
      <<~GQL
        query searchPlaylists($query: String!) {
          searchPlaylists(query: $query) {
            edges {
              node {
                id
                title
                playlistItems {
                  id
                  playable {
                    ... on Recording {
                      id
                      title
                      audioTransfers {
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
          }
        }
      GQL
    end

    it "returns the correct playlist details, including recordings and audio variants" do
      gql(query, variables: {query: "Awesome"}, user:)

      expect(gql_errors).to be_empty

      playlists_data = data.search_playlists.edges
      expect(playlists_data).not_to be_empty

      first_playlist = playlists_data.first.node
      expect(first_playlist.title).to eq("Awesome Playlist")
      expect(first_playlist.id).to eq(playlist.id.to_s)

      playlist_items = first_playlist.playlist_items
      expect(playlist_items).not_to be_empty

      first_playable = playlist_items.first.playable
      expect(first_playable.id).to eq(recording.id.to_s)
      expect(first_playable.title).to eq(recording.title)

      first_audio_transfer_data = first_playable.audio_transfers.first
      expect(first_audio_transfer_data.id).to eq(audio_variant.audio_transfer.id.to_s)

      audio_variant_data = first_audio_transfer_data.audio_variants.first
      expect(audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(audio_variant_data.audio_file_url).to be_present
    end
  end
end
