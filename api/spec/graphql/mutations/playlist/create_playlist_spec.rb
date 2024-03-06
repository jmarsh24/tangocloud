require "rails_helper"

RSpec.describe "CreatePlaylist", type: :graph do
  let!(:user) { users(:normal) }
  let!(:volver_a_sonar) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
  let!(:milonga_vieja) { audio_transfers(:milonga_vieja_milonga_19370922_aif) }

  describe "create playlist" do
    let(:mutation) do
      <<~GQL
        mutation CreatePlaylist($title: String!, $description: String, $itemIds: [ID]) {
          createPlaylist(input: {title: $title, description: $description, itemIds: $itemIds}) {
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

    it "successfully creates a playlist" do
      gql(mutation, variables: {title: "Test Playlist"}, user:)

      expect(result.data.create_playlist.playlist.title).to eq("Test Playlist")
    end

    it "returns errors when title is missing" do
      gql(mutation, variables: {title: ""}, user:)

      expect(result.data.create_playlist.errors).to eq(["Title can't be blank"])
    end

    it "creates a playlist with items" do
      gql(mutation, variables: {title: "Test Playlist", itemIds: [volver_a_sonar.id, milonga_vieja.id]}, user:)

      expected_playlist_titles = result.data.create_playlist.playlist.audio_transfers.map { _1.recording.title }
      expect(expected_playlist_titles).to eq(["Volver a soñar", "Milonga vieja milonga"])
    end
  end
end
