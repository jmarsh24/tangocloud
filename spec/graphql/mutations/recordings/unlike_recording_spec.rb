require "rails_helper"

RSpec.describe "LikeRecording", type: :graph do
  let(:user) { create(:user) }
  let(:recording) { create(:recording) }
  let(:like) { create(:like, likeable: recording, user:) }

  let(:mutation) do
    <<~GQL
      mutation LikeRecording($recordingId: ID!) {
        LikeRecording(input: { recordingId: $recordingId }) {
          success
          errors
        }
      }
    GQL
  end

  describe "LikeRecording" do
    it "s a like" do
      like_id = like.id
      gql(mutation, variables: {recordingId: recording.id}, user:)

      expect(data._like__recording.success).to be_truthy
      expect(Like.exists?(id: like_id)).to be_falsey
    end
  end
end
