require "rails_helper"

RSpec.describe "CreatePlayback", type: :graph do
  let(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation createPlayback($recordingId: ID!) {
        createPlayback(input: { recordingId: $recordingId }) {
          playback {
            id
            createdAt
            recording {
              id
            }
            user {
              id
            }
          }
        }
      }
    GQL
  end

  let(:recording) { recordings(:volver_a_sonar) }

  it "creates a playback" do
    gql(mutation, variables: {recordingId: recording.id}, user:)

    expect(result.data.create_playback.playback.recording.id).to eq(recording.id.to_s)
    expect(result.data.create_playback.playback.user.id).to eq(user.id.to_s)
    expect(result.data.create_playback.playback.created_at).to be_present
  end
end
