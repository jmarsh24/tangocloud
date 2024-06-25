require "rails_helper"

RSpec.describe "AddPlaylistRecording", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { playlists(:awesome_playlist) }
  let!(:volver_a_sonar) { recordings(:volver_a_sonar) }
  let!(:milonga_vieja) { recordings(:milonga_vieja_milonga) }
  let!(:mutation) do
    <<~GQL
      mutation AddPlaylistRecording($playlistId: ID!, $recordingId: ID!) {
        addPlaylistRecording(input: {playlistId: $playlistId, recordingId: $recordingId}) {
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

  describe "add playlist recording" do
    it "successfully adds an recording to a playlist" do
      gql(mutation, variables: {playlistId: playlist.id, recordingId: volver_a_sonar.id}, user:)

      playlist_title = result.data.add_playlist_recording.playlist_item.playlist.title
      item_title = result.data.add_playlist_recording.playlist_item.item.title
      position = result.data.add_playlist_recording.playlist_item.position

      expect(playlist_title).to eq("Awesome Playlist")
      expect(item_title).to eq("Volver a soñar")
      expect(position).to eq(3)
      expect(result.data.add_playlist_recording.errors).to be_empty
    end
  end
end
