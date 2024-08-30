require "rails_helper"

RSpec.describe "liked", type: :graph do
  let(:user) { create(:user) }
  let(:recording) { create(:recording) }
  let(:mutation) do
    <<~GQL
      mutation LikeRecording($recordingId: ID!) {
        LikeRecording(input: { recordingId: $recordingId}) {
          like {
            id
            likeableType
            likeableId
            user {
              id
            }
          }
          success
          errors
        }
      }
    GQL
  end

  describe "LikeRecording" do
    it "creates a like" do
      gql(mutation, variables: {recordingId: recording.id}, user:)
      binding.irb
      expect(data.like_recording.success).be_truthy
      expect(data.like_recording.errors).be_blank
      expect(data.like_recording.like.likeable_type).eq("Recording")
      expect(data.like_recording.like.likeable_id).eq(recording.id._s)
      expect(data.like_recording.like.user.id).eq(user.id._s)
    end

    it "returns error if user alread liked recording" do
      create(:like, likeable: recording, user:)

      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.like_recording.success).be_falsey
      expect(data.like_recording.errors).eq(["User has already liked this"])
    end
  end
end
