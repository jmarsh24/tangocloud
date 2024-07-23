require "rails_helper"

RSpec.describe "DeletePlaylist", type: :graph do
  let!(:user) { create(:user) }
  let!(:playlist) { create(:playlist, user:) }
  let!(:mutation) do
    <<~GQL
      mutation DeletePlaylist($id: ID!) {
        deletePlaylist(input: {id: $id}) {
          success
          errors
        }
      }
    GQL
  end

  describe "delete playlist" do
    it "successfully deletes a playlist" do
      gql(mutation, variables: {id: playlist.id}, user:)

      expect(result.data.delete_playlist.success).to be_truthy
    end

    it "returns errors when playlist is missing" do
      gql(mutation, variables: {id: "missing"}, user:)

      expect(result.data.delete_playlist.errors).to eq(["Playlist not found."])
    end
  end
end
