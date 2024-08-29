require "rails_helper"

RSpec.describe "CreatePlayback", type: :graph do
  let!(:mutation) do
    <<~GQL
      mutation CreatePlayback($recordingId: ID!) {
        createPlayback(input: {recordingId: $recordingId}) {
          playback {
            id
            recording {
              id
              title
            }
            user {
              id
              username
            }
          }
          errors
        }
      }
    GQL
  end

  describe "createPlayback" do
    it "creates a playback" do
      recording = create(:recording)
      user = create(:user)
      variables = {recordingId: recording.id}

      gql(mutation, variables:, user:)

      expect(Playback.count).to eq(1)

      playback = Playback.last
      expect(playback.recording).to eq(recording)
      expect(playback.user).to eq(user)

      expect(data.create_playback.playback.id).to eq(playback.id.to_s)
      expect(data.create_playback.playback.recording.id).to eq(recording.id.to_s)
      expect(data.create_playback.playback.user.id).to eq(user.id.to_s)
    end
  end
end
