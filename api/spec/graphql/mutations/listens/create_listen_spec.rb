require "rails_helper"

RSpec.describe "CreateListen", type: :graph do
  let(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation createListen($recordingId: ID!) {
        createListen(input: { recordingId: $recordingId }) {
          listen {
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

  it "creates a listen" do
    gql(mutation, variables: {recordingId: recording.id}, user:)

    expect(result.data.create_listen.listen.recording.id).to eq(recording.id.to_s)
    expect(result.data.create_listen.listen.user.id).to eq(user.id.to_s)
    expect(result.data.create_listen.listen.created_at).to be_present
  end
end
