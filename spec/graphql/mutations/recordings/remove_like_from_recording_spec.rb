require "rails_helper"

RSpec.describe "removeLikeFromRecording", type: :graph do
  let(:user) { create(:user) }
  let(:recording) { create(:recording) }
  let(:like) { create(:like, likeable: recording, user:) }

  let(:mutation) do
    <<~GQL
      mutation RemoveLikeFromRecording($recordingId: ID!) {
        removeLikeFromRecording(input: { recordingId: $recordingId }) {
          success
          errors
        }
      }
    GQL
  end

  describe "RemoveLikeFromRecording" do
    it "removes a like" do
      like_id = like.id
      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data.remove_like_from_recording.success).to be_truthy
      expect(Like.exists?(id: like_id)).to be_falsey
    end
  end
end
