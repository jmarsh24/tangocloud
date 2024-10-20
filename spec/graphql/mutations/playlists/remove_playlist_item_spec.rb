require "rails_helper"

RSpec.describe "RemovePlaylistItem", type: :graph do
  let!(:user) { create(:user, :approved) }
  let!(:playlist) { create(:playlist, user:) }
  let!(:volver_a_sonar_composition) { create(:composition, title: "Volver a soñar") }
  let!(:volver_a_sonar) { create(:recording, composition: volver_a_sonar_composition) }
  let!(:playlist_item) { create(:playlist_item, playlist:, item: volver_a_sonar) }

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
