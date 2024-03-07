require "rails_helper"

RSpec.describe "AddPlaylistItem", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:volver_a_sonar) { recordings(:volver_a_sonar) }
  let!(:milonga_vieja) { recordings(:milonga_vieja_milonga) }
  let!(:mutation) do
    <<~GQL
      mutation AddPlaylistItem($playlistId: ID!, $playableId: ID!, $playableType: String!) {
        addPlaylistItem(input: {playlistId: $playlistId, playableId: $playableId, playableType: $playableType}) {
          playlistItem {
            id
            position
            playlist {
              id
              title
            }
            playable {
              ... on Recording {
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
      gql(mutation, variables: {playlistId: playlist.id, playableId: volver_a_sonar.id, playableType: "Recording"}, user:)

      playlist_title = result.data.add_playlist_item.playlist_item.playlist.title
      playable_title = result.data.add_playlist_item.playlist_item.playable.title
      position = result.data.add_playlist_item.playlist_item.position

      expect(playlist_title).to eq("Awesome Playlist")
      expect(playable_title).to eq("Volver a soñar")
      expect(position).to eq(2)
      expect(result.data.add_playlist_item.errors).to be_empty
    end
  end
end
