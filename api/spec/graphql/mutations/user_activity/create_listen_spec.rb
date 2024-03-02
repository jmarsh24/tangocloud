require "rails_helper"

RSpec.describe "CreateListen", type: :request do
  let(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation createListen($recordingId: ID!) {
        createListen(input: {
          recordingId: $recordingId
        }) {
          listen {
            id
            user {
              id
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
    post api_graphql_path, params: {query: mutation, variables: {recordingId: recording.id}}, headers: {"Authorization" => "Bearer #{user.auth_token}"}
    json = JSON.parse(response.body)
    expect(json.dig("data", "createListen", "listen", "user", "id")).to eq(user.id.to_s)
    expect(json.dig("data", "createListen", "listen", "recording", "id")).to eq(recording.id.to_s)
    expect(json.dig("data", "createListen", "errors")).to be_empty
  end
end
