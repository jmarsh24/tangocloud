require "rails_helper"

RSpec.describe "Playlists", type: :graph do
  describe "Fetching playlists" do
    let!(:user) { create(:user) }
    let!(:playlist) { create(:playlist, :public, title: "Awesome Playlist", user:) }
    let!(:recording) { create(:recording, title: "Awesome Recording") }
    let!(:playlist_item) { create(:playlist_item, playlist:, item: recording) }
    let!(:audio_transfer) { create(:audio_transfer, recording:) }
    let!(:audio_variant) { create(:audio_variant, audio_transfer:) }

    let(:query) do
      <<~GQL
        query Playlists($query: String) {
          playlists(query: $query) {
            edges {
              node {
                id
                title
                playlistItems {
                  edges {
                    node {
                      id
                      item {
                        ... on Recording {
                          id
                          title
                          audioTransfers {
                            edges {
                              node {
                                id
                                audioVariants {
                                  edges {
                                    node {
                                      id
                                      audioFile {
                                        blob {
                                          url
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
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
      Playlist.reindex

      gql(query, variables: {query: "Awesome"}, user:)

      expect(gql_errors).to be_empty

      playlists_data = data.playlists.edges
      expect(playlists_data).not_to be_empty

      first_playlist = playlists_data.first.node
      expect(first_playlist.title).to eq("Awesome Playlist")
      expect(first_playlist.id).to eq(playlist.id)

      playlist_items = first_playlist.playlist_items.edges
      expect(playlist_items).not_to be_empty

      first_playlist_item = playlist_items.first.node
      first_item = first_playlist_item.item
      expect(first_item.id).to eq(recording.id)
      expect(first_item.title).to eq(recording.title)

      first_audio_transfer = first_item.audio_transfers.edges.first.node
      expect(first_audio_transfer.id).to eq(audio_variant.audio_transfer.id)

      audio_variant_data = first_audio_transfer.audio_variants.edges.first.node
      expect(audio_variant_data.id).to eq(audio_variant.id)
      expect(audio_variant_data.audio_file.blob.url).to be_present
    end
  end
end
