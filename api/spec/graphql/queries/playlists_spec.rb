require "rails_helper"

RSpec.describe "Playlists", type: :graph do
  describe "Fetching playlists" do
    let!(:user) { users(:normal) }
    let!(:playlist) { playlists(:awesome_playlist) }
    let!(:recording) { recordings(:volver_a_sonar) }
    let!(:audio_variant) { audio_variants(:volver_a_sonar_rufino_aac) }

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
                      playable {
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
      gql(query, variables: {query: "Awesome"}, user:)

      expect(gql_errors).to be_empty

      playlists_data = data.playlists.edges
      expect(playlists_data).not_to be_empty

      first_playlist = playlists_data.first.node
      expect(first_playlist.title).to eq("Awesome Playlist")
      expect(first_playlist.id).to eq(playlist.id.to_s)

      playlist_items = first_playlist.playlist_items.edges
      expect(playlist_items).not_to be_empty

      first_playlist_item = playlist_items.first.node
      first_playable = first_playlist_item.playable
      expect(first_playable.id).to eq(recording.id.to_s)
      expect(first_playable.title).to eq(recording.title)

      first_audio_transfer = first_playable.audio_transfers.edges.first.node
      expect(first_audio_transfer.id).to eq(audio_variant.audio_transfer.id.to_s)

      audio_variant_data = first_audio_transfer.audio_variants.edges.first.node
      expect(audio_variant_data.id).to eq(audio_variant.id.to_s)
      expect(audio_variant_data.audio_file.blob.url).to be_present
    end
  end
end
