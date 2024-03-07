require "rails_helper"

RSpec.describe "RemovePlaylistItem", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:playlist_item) { playlist_items(:awesome_playlist_item_1) }

  let!(:mutation) do
    <<~GQL
      mutation RemovePlaylistItem($playlistItemId: ID!) {
        removePlaylistItem(input: {playlistItemId: $playlistItemId}) {
          success
          errors
        }
      }
    GQL
  end

  describe "remove item from playlist" do
    it "successfully removes an item from a playlist" do
      gql(mutation, variables: {playlistItemId: playlist_item.id}, user:)

      expect(result.data.remove_playlist_item.success).to be_truthy
    end

    it "returns errors when item is missing" do
      gql(mutation, variables: {playlistItemId: "missing"}, user:)

      expect(result.data.remove_playlist_item.errors).to eq(["Playlist item not found"])
    end
  end
end
