require "rails_helper"

RSpec.describe "ReorderPlaylistItems", type: :graph do
  let!(:user) { users(:normal) }
  let!(:playlist) { Playlist.create!(title: "Test Playlist", user:) }
  let!(:milonga_vieja_milonga) { audio_transfers(:milonga_vieja_milonga_19370922_aif) }
  let!(:volver_a_sonar) { audio_transfers(:volver_a_sonar_rufino_19401008_flac) }
  let!(:farol) { audio_transfers(:farol_chanel_19430715_flac) }

  before do
    playlist.audio_transfers << [milonga_vieja_milonga, volver_a_sonar, farol]

    playlist.playlist_audio_transfers.each_with_index do |pat, index|
      pat.update(position: index + 1)
    end
  end

  describe "reorder playlist items" do
    let(:mutation) do
      <<~GQL
        mutation ReorderPlaylistItems($playlistId: ID!, $itemIds: [ID!]!) {
          reorderPlaylistItems(input: {playlistId: $playlistId, itemIds: $itemIds}) {
            playlist {
              audioTransfers {
                id
                position
              }
            }
            errors
          }
        }
      GQL
    end

    it "successfully reorders the playlist" do
      items = [farol, milonga_vieja_milonga, volver_a_sonar]
      gql(mutation, variables: {playlistId: playlist.id, itemIds: items.map(&:id)}, user:)

      expected_recording_titles = [farol, milonga_vieja_milonga, volver_a_sonar].map { _1.recording.title }
      playlist_recording_titles = playlist.audio_transfers.map { _1.recording.title }
      expect(playlist_recording_titles).to eq(expected_recording_titles)
    end
  end
end
