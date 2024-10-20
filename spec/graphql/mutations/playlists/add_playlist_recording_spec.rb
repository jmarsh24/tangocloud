require "rails_helper"

RSpec.describe "AddPlaylistRecording", type: :graph do
  let!(:user) { create(:user, :approved) }
  let!(:playlist) { create(:playlist, title: "Awesome Playlist", user:) }
  let!(:composition) { create(:composition, title: "Volver a soñar") }
  let!(:recording) { create(:recording, composition:) }

  let!(:mutation) do
    <<~GQL
      mutation AddPlaylistRecording($playlistId: ID!, $recordingId: ID!) {
        addPlaylistRecording(input: {playlistId: $playlistId, recordingId: $recordingId}) {
          playlistItem {
            id
            position
            playlist {
              __typename
              ... on Playlist {
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

  describe "add playlist recording" do
    it "successfully adds a recording to a playlist" do
      gql(mutation, variables: {playlistId: playlist.id, recordingId: recording.id}, user:)

      playlist = result.data.add_playlist_recording.playlist_item.playlist
      item = result.data.add_playlist_recording.playlist_item.item
      position = result.data.add_playlist_recording.playlist_item.position

      expect(playlist.__typename).to eq("Playlist")
      expect(playlist.title).to eq("Awesome Playlist")
      expect(item.__typename).to eq("Recording")
      expect(item.composition.title).to eq("Volver a soñar")
      expect(position).to eq(1)
      expect(result.data.add_playlist_recording.errors).to be_empty
    end

    it "returns an error when the playlist does not exist" do
      gql(mutation, variables: {playlistId: "non-existent-id", recordingId: recording.id}, user:)

      expect(result.data.add_playlist_recording.errors).not_to be_empty
    end

    it "returns an error when the recording does not exist" do
      gql(mutation, variables: {playlistId: playlist.id, recordingId: "non-existent-id"}, user:)

      expect(result.data.add_playlist_recording.errors).not_to be_empty
    end
  end
end
