require "rails_helper"

RSpec.describe "Playlists", type: :graph do
  describe "Fetching playlists" do
    let!(:user) { create(:user, :approved) }
    let!(:playlist) { create(:playlist, :public, title: "Awesome Playlist", user:) }
    let!(:composition) { create(:composition, title: "Awesome Recording") }
    let!(:recording) { create(:recording, composition:) }
    let!(:playlist_item) { create(:playlist_item, playlistable: playlist, item: recording) }
    let!(:digital_remaster) { create(:digital_remaster, recording:) }
    let!(:audio_variant) { create(:audio_variant, digital_remaster:) }

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
                          composition {
                            title
                          }
                          digitalRemasters {
                            edges {
                              node {
                                id
                                audioVariants {
                                  edges {
                                    node {
                                      id
                                      audioFile {
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
      expect(first_item.composition.title).to eq(recording.title)

      first_digital_remaster = first_item.digital_remasters.edges.first.node
      expect(first_digital_remaster.id).to eq(audio_variant.digital_remaster.id)

      audio_variant_data = first_digital_remaster.audio_variants.edges.first.node
      expect(audio_variant_data.id).to eq(audio_variant.id)
      expect(audio_variant_data.audio_file.url).to be_present
    end
  end
end
