require "rails_helper"

RSpec.describe "RemoveItemFromPlaylist", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:volver_a_sonar) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
  let!(:mutation) do
    <<~GQL
      mutation RemoveItemFromPlaylist($playlistId: ID!, $itemId: ID!) {
        removeItemFromPlaylist(input: {playlistId: $playlistId, itemId: $itemId}) {
          success
          errors
        }
      }
    GQL
  end

  describe "remove item from playlist" do
    it "successfully removes an item from a playlist" do
      gql(mutation, variables: {playlistId: playlist.id, itemId: volver_a_sonar.id}, user:)

      expect(result.data.remove_item_from_playlist.success).to be_truthy
      expect(playlist.reload.audio_transfers).to be_empty
    end

    it "returns errors when item is missing" do
      gql(mutation, variables: {playlistId: playlist.id, itemId: "missing"}, user:)

      expect(result.data.remove_item_from_playlist.errors).to eq(["Playlist audio transfer not found."])
    end

    it "returns errors when playlist is missing" do
      gql(mutation, variables: {playlistId: "missing", itemId: volver_a_sonar.id}, user:)

      expect(result.data.remove_item_from_playlist.errors).to eq(["Playlist not found."])
    end
  end
end
