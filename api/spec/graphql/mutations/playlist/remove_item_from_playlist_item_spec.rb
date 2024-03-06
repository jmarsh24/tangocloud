require "rails_helper"

RSpec.describe "RemoveItemFromPlaylist", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:volver_a_sonar) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
  let!(:mutation) do
    <<~GQL
      mutation RemoveItemFromPlaylist($playlistItemId: ID!) {
        removeItemFromPlaylist(input: {playlistItemId: $playlistItemId}) {
          success
          errors
        }
      }
    GQL
  end

  describe "remove item from playlist" do
    it "successfully removes an item from a playlist" do
      gql(mutation, variables: {playlistItemId: playlist.playlist_audio_transfers.first.id}, user:)

      expect(result.data.remove_item_from_playlist.success).to be_truthy
    end

    it "returns errors when item is missing" do
      gql(mutation, variables: {playlistItemId: "missing"}, user:)

      expect(result.data.remove_item_from_playlist.errors).to eq(["Playlist audio transfer not found."])
    end
  end
end
