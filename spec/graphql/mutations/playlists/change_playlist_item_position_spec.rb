require "rails_helper"

RSpec.describe "ChangePlaylistItemPosition", type: :graph do
  let!(:user) { create(:user, :approved) }
  let!(:playlist) { create(:playlist, title: "Awesome Playlist", user:) }
  let!(:tanda) { create(:tanda, title: "Tanda 1", user:) }

  let!(:composition1) { create(:composition, title: "Volver a soñar") }
  let!(:volver_a_sonar) { create(:recording, composition: composition1) }

  let!(:composition2) { create(:composition, title: "Milonga vieja") }
  let!(:milonga_vieja) { create(:recording, composition: composition2) }

  let!(:composition3) { create(:composition, title: "La Cumparsita") }
  let!(:cumparsita_recording) { create(:recording, composition: composition3) }

  let!(:volver_a_sonar_item) { create(:playlist_item, playlistable: playlist, item: volver_a_sonar, position: 1) }
  let!(:milonga_vieja_item) { create(:playlist_item, playlistable: playlist, item: milonga_vieja, position: 2) }
  let!(:cumparsita_item) { create(:playlist_item, playlistable: playlist, item: cumparsita_recording, position: 3) }

  let!(:tanda_volver_item) { create(:playlist_item, playlistable: tanda, item: volver_a_sonar, position: 1) }
  let!(:tanda_milonga_item) { create(:playlist_item, playlistable: tanda, item: milonga_vieja, position: 2) }

  let!(:mutation) do
    <<~GQL
      mutation ChangePlaylistItemPosition($playlistItemId: ID!, $position: Int!) {
        changePlaylistItemPosition(input: {playlistItemId: $playlistItemId, position: $position}) {
          playlistItem {
            id
            position
            playlistable {
              __typename
              ... on Playlist {
                id
                title
              }
              ... on Tanda {
                id
                title
              }
            }
            item {
              __typename
              ... on Recording {
                id
                composition {
                  title
                }
              }
              ... on Tanda {
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
    context "for Playlist" do
      it "successfully changes the position of a playlist item in a Playlist" do
        gql(mutation, variables: {playlistItemId: volver_a_sonar_item.id, position: 2}, user:)

        playlistable = result.data.change_playlist_item_position.playlist_item.playlistable
        item = result.data.change_playlist_item_position.playlist_item.item
        position = result.data.change_playlist_item_position.playlist_item.position

        expect(playlistable.__typename).to eq("Playlist")
        expect(playlistable.title).to eq("Awesome Playlist")
        expect(item.__typename).to eq("Recording")
        expect(item.composition.title).to eq("Volver a soñar")
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

    context "for Tanda" do
      it "successfully changes the position of a playlist item in a Tanda" do
        gql(mutation, variables: {playlistItemId: tanda_volver_item.id, position: 2}, user:)

        playlistable = result.data.change_playlist_item_position.playlist_item.playlistable
        item = result.data.change_playlist_item_position.playlist_item.item
        position = result.data.change_playlist_item_position.playlist_item.position

        expect(playlistable.__typename).to eq("Tanda")
        expect(playlistable.title).to eq("Tanda 1")
        expect(item.__typename).to eq("Recording")
        expect(item.composition.title).to eq("Volver a soñar")
        expect(position).to eq(2)
        expect(result.data.change_playlist_item_position.errors).to be_empty
      end

      it "returns an error when the position is invalid for Tanda" do
        gql(mutation, variables: {playlistItemId: tanda_volver_item.id, position: -1}, user:)

        expect(result.data.change_playlist_item_position.playlist_item).to be_nil
        expect(result.data.change_playlist_item_position.errors).to include("Position must be greater than or equal to 1")
      end
    end
  end
end
