require "rails_helper"

RSpec.describe "liked", type: :graph do
  let(:user) { create(:user) }
  let(:recording) { create(:recording) }
  let(:mutation) do
    <<~GQL
      mutation AddLikeToRecording($recordingId: ID!) {
        addLikeToRecording(input: { recordingId: $recordingId}) {
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

  describe "AddLikeToRecording" do
    it "creates a like" do
      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.add_like_to_recording.success).to be_truthy
      expect(data.add_like_to_recording.errors).to be_blank
      expect(data.add_like_to_recording.like.likeable_type).to eq("Recording")
      expect(data.add_like_to_recording.like.likeable_id).to eq(recording.id.to_s)
      expect(data.add_like_to_recording.like.user.id).to eq(user.id.to_s)
    end

    it "returns error if user alread liked recording" do
      create(:like, likeable: recording, user:)

      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.add_like_to_recording.success).to be_falsey
      expect(data.add_like_to_recording.errors).to eq(["User has already liked this"])
    end
  end
end
