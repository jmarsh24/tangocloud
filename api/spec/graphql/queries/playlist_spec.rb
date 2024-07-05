require "rails_helper"

RSpec.describe "Playlist", type: :graph do
  describe "playlist" do
    let!(:user) { create(:user) }
    let!(:audio_file) { create(:audio_file) }
    let!(:audio_transfer) { create(:audio_transfer, audio_file:) }
    let!(:audio_variant) { create(:audio_variant, audio_transfer:) }
    let!(:recording) { create(:recording, audio_transfers: [audio_transfer]) }
    let!(:playlist_item) { create(:playlist_item, playlist:, item: recording) }
    let!(:playlist) { create(:playlist, user:) }

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
      expect(recording_data.title).to eq(recording.title)

      first_audio_transfer_data = recording_data.audio_transfers.edges.first.node
      expect(first_audio_transfer_data).not_to be_nil

      first_audio_variant_data = first_audio_transfer_data.audio_variants.edges.first.node
      expect(first_audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(first_audio_variant_data.audio_file.blob.url).to be_present
    end
  end
end
