require "rails_helper"

RSpec.describe "CreateListen", type: :request do
  let(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation createRecordingListen($recordingId: ID!) {
        createRecordingListen(input: {
          recordingId: $recordingId
        }) {
          recordingListen {
            id
            createdAt
            userHistory {
              user {
                id
              }
            }
            recording {
              id
            }
          }
          errors
        }
      }
    GQL
  end
  let(:recording) { recordings(:volver_a_sonar) }

  it "creates a listen" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {recordingId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "createRecordingListen", "recordingListen", "userHistory", "user", "id")).to eq(user.id.to_s)
    expect(json.dig("data", "createRecordingListen", "recordingListen", "recording", "id")).to eq(recording.id.to_s)
    expect(json.dig("data", "createRecordingListen", "recordingListen", "createdAt")).to be_present
    expect(json.dig("data", "createRecordingListen", "recordingListen", "errors")).to be_nil
  end

  it "requires authentication" do
    post api_graphql_path, params: {query: mutation, variables: {recordingId: recording.id}}
    json = JSON.parse(response.body)

    expect(json.dig("errors", 0)).to eq("You must be signed in to access this resource.")
  end
end
