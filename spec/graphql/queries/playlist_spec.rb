require "rails_helper"

RSpec.describe "Playlist", type: :graph do
  describe "playlist" do
    let!(:user) { create(:user, :approved) }
    let!(:audio_file) { create(:audio_file) }
    let!(:orchestra) { create(:orchestra) }
    let!(:genre) { create(:genre) }
    let!(:composition) { create(:composition) }
    let!(:recording) { create(:recording, orchestra:, genre:, composition:) }
    let!(:digital_remaster) { create(:digital_remaster, recording:, audio_file:) }
    let!(:audio_variant) { create(:audio_variant, digital_remaster:) }
    let!(:playlist) { create(:playlist, user:) }
    let!(:playlist_item) { create(:playlist_item, playlistable: playlist, item: recording) }
    let(:query) do
      <<~GQL
        query Playlist($id: ID!) {
          playlist(id: $id) {
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
      GQL
    end

    it "returns the correct playlist details, including recordings and audio variants" do
      gql(query, variables: {id: playlist.id.to_s}, user:)
      playlist_data = result.data.playlist

      expect(playlist_data.title).to eq(playlist.title)
      expect(playlist_data.id).to eq(playlist.id.to_s)

      first_playlist_item_data = playlist_data.playlist_items.edges.first.node
      expect(first_playlist_item_data).not_to be_nil

      item_data = first_playlist_item_data.item
      expect(item_data).not_to be_nil

      recording_data = item_data
      expect(recording_data.id).to eq(recording.id.to_s)
      expect(recording_data.composition.title).to eq(recording.title)
      first_digital_remaster_data = recording_data.digital_remasters.edges.first.node
      expect(first_digital_remaster_data).not_to be_nil

      first_audio_variant_data = first_digital_remaster_data.audio_variants.edges.first.node

      expect(first_audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(first_audio_variant_data.audio_file.blob?.url).to be_present
    end
  end
end
