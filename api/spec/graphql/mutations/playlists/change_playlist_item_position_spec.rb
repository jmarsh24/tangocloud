# spec/graphql/mutations/change_playlist_item_position_spec.rb

require "rails_helper"

RSpec.describe "ChangePlaylistItemPosition", type: :graph do
  let!(:user) { create(:user) }
  let!(:playlist) { create(:playlist, title: "Awesome Playlist", user:) }
  let!(:volver_a_sonar) { create(:recording, composition_title: "Volver a soñar") }
  let!(:milonga_vieja) { create(:recording, composition_title: "Milonga vieja") }
  let!(:volver_a_sonar_item) { create(:playlist_item, playlist:, item: volver_a_sonar, position: 1) }
  let!(:milonga_vieja_item) { create(:playlist_item, playlist:, item: milonga_vieja, position: 2) }

  let!(:mutation) do
    <<~GQL
      mutation ChangePlaylistItemPosition($playlistItemId: ID!, $position: Int!) {
        changePlaylistItemPosition(input: {playlistItemId: $playlistItemId, position: $position}) {
          playlistItem {
            id
            position
            playlist {
              id
              title
            }
            item {
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

  describe "change playlist item position" do
    it "successfully changes the position of a playlist item" do
      gql(mutation, variables: {playlistItemId: volver_a_sonar_item.id, position: 2}, user:)

      playlist_title = result.data.change_playlist_item_position.playlist_item.playlist.title
      item_title = result.data.change_playlist_item_position.playlist_item.item.title
      position = result.data.change_playlist_item_position.playlist_item.position

      expect(playlist_title).to eq("Awesome Playlist")
      expect(item_title).to eq("Volver a soñar")
      expect(position).to eq(2)
      expect(result.data.change_playlist_item_position.errors).to be_empty
    end

    it "returns an error when the playlist item is not found" do
      gql(mutation, variables: {playlistItemId: "non_existent_id", position: 1}, user:)

      expect(result.data.change_playlist_item_position.playlist_item).to be_nil
      expect(result.data.change_playlist_item_position.errors).to eq(["Playlist item not found"])
    end

    it "returns an error when the position is invalid" do
      gql(mutation, variables: {playlistItemId: volver_a_sonar_item.id, position: -1}, user:)

      expect(result.data.change_playlist_item_position.playlist_item).to be_nil
      expect(result.data.change_playlist_item_position.errors).to include("Position must be greater than or equal to 1")
    end
  end
end
