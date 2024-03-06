require "rails_helper"

RSpec.describe "AddPlaylistItem", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:volver_a_sonar) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
  let!(:milonga_vieja) { audio_transfers(:milonga_vieja_milonga_19370922_aif) }
  let!(:mutation) do
    <<~GQL
      mutation AddPlaylistItem($playlistId: ID!, $itemId: ID!, $position: Int) {
        addPlaylistItem(input: {playlistId: $playlistId, itemId: $itemId, position: $position}) {
          playlist {
            id
            title
            audioTransfers {
              id
              position
              recording {
                id
                title
              }
            }
          }
          errors
        }
      }
    GQL
  end

  describe "add playlist item" do
    it "successfully adds an item to a playlist" do
      gql(mutation, variables: {playlistId: playlist.id, itemId: volver_a_sonar.id}, user:)

      expected_playlist_titles = result.data.add_playlist_item.playlist.audio_transfers.map { _1.recording.title }
      expect(expected_playlist_titles).to eq(["Volver a soñar", "Volver a soñar"])
    end

    it "successfully adds an item to a playlist at a specific position" do
      gql(mutation, variables: {playlistId: playlist.id, itemId: milonga_vieja.id, position: 1}, user:)

      expected_playlist_titles = result.data.add_playlist_item.playlist.audio_transfers.map { _1.recording.title }
      expect(expected_playlist_titles).to eq(["Milonga vieja milonga", "Volver a soñar"])
    end
  end
end
