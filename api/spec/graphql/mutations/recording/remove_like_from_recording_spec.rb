require "rails_helper"

RSpec.describe "RemoveLikeFromRecordingRecording", type: :graph do
  let(:user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:like) { likes(:normal_user_like) }
  let(:mutation) do
    <<~GQL
      mutation RemoveLikeFromRecording($id: ID!) {
        removeLikeFromRecording(input: { id: $id}) {
          success
          errors
        }
      }
    GQL
  end

  it "destroys a like" do
    gql(mutation, variables: {id: like.id}, user:)

    expect(data.remove_like_from_recording.success).to be_truthy
    expect(Like.exists?(id: like.id)).to be_falsey
  end

  it "returns an error if the like does not exist" do
    gql(mutation, variables: {id: 0}, user: user)

    expect(data.remove_like_from_recording.success).to be_falsey
    expect(data.remove_like_from_recording.errors).to eq(["Like not found"])
  end
end
