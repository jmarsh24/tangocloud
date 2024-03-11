require "rails_helper"

RSpec.describe "removePlayback", type: :graph do
  let(:user) { users(:normal) }
  let(:playback) { playbacks(:volver_a_sonar_normal_playback) }
  let(:recording) { playback.recording }
  let(:mutation) do
    <<~GQL
      mutation removePlayback($id: ID!) {
        removePlayback(input: {
          id: $id
        }) {
          success
          errors
        }
      }
    GQL
  end

  it "removes a playback" do
    gql(mutation, variables: {id: playback.id}, user:)

    expect(data.remove_playback.success).to be true
    expect(Playback.exists?(playback.id)).to be false
  end

  it "returns an error if the listen does not exist" do
    gql(mutation, variables: {id: 0}, user:)

    expect(data.remove_playback.errors.first).to eq("Couldn't find Playback with 'id'=0")
    expect(data.remove_playback.success).to be false
    expect(Playback.exists?(playback.id)).to be true
  end
end
