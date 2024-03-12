require "rails_helper"

RSpec.describe "checkLikeStatusOnRecording", type: :graph do
  let(:admin) { users(:admin) }
  let(:normal_user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:query) do
    <<-GQL
      query checkLikeStatusOnRecording($recordingId: ID!) {
        checkLikeStatusOnRecording(recordingId: $recordingId)
      }
    GQL
  end

  describe "check_like_status_on_recording" do
    it "returns true if the user has liked the recording" do
      gql(query, variables: {recordingId: recording.id}, user: normal_user)

      expect(data.check_like_status_on_recording).to eq(true)
    end

    it "returns false if the user has not liked the recording" do
      gql(query, variables: {recordingId: recording.id}, user: admin)
      expect(data.check_like_status_on_recording).to eq(false)
    end
  end
end
