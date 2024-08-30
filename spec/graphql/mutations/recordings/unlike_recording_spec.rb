require "rails_helper"

RSpec.describe "LikeRecording", type: :graph do
  let(:user) { create(:user) }
  let(:recording) { create(:recording) }
  let(:like) { create(:like, likeable: recording, user:) }

  let(:mutation) do
    <<~GQL
      mutation UnlikeRecording($recordingId: ID!) {
        unlikeRecording(input: { recordingId: $recordingId }) {
          success
          errors
        }
      }
    GQL
  end

  describe "unlikeRecording" do
    it "unlikes a recording" do
      like_id = like.id
      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.unlike_recording.success).to be_truthy
      expect(Like.exists?(id: like_id)).to be_falsey
    end
  end
end
