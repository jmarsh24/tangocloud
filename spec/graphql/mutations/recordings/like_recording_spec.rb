require "rails_helper"

RSpec.describe "liked", type: :graph do
  let(:user) { create(:user, :approved) }
  let(:recording) { create(:recording) }
  let(:mutation) do
    <<~GQL
      mutation LikeRecording($recordingId: ID!) {
        likeRecording(input: { recordingId: $recordingId}) {
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

      expect(data.like_recording.success).to be_truthy
      expect(data.like_recording.errors).to be_blank
      expect(data.like_recording.like.likeable_type).to eq("Recording")
      expect(data.like_recording.like.likeable_id).to eq(recording.id)
      expect(data.like_recording.like.user.id).to eq(user.id)
    end

    it "returns error if user alread liked recording" do
      create(:like, likeable: recording, user:)

      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.like_recording.success).to be_falsey
      expect(data.like_recording.errors).to eq(["User has already liked this"])
    end
  end
end
