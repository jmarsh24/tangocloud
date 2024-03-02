require "rails_helper"

RSpec.describe "likeRecording", type: :request do
  let(:user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:mutation) do
    <<~GQL
      mutation likeRecording($id: ID!) {
        likeRecording(input: { id: $id}) {
            like {
              id
              user {
                id
              }
              likeableType
              likeableId
            }
            success
            errors {
              details
              fullMessages
            }
          }
        }
    GQL
  end

  it "creates a like" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {id: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "likeRecording", "like", "user", "id")).to eq(user.id.to_s)
    expect(json.dig("data", "likeRecording", "like", "likeableType")).to eq("Recording")
    expect(json.dig("data", "likeRecording", "like", "likeableId")).to eq(recording.id.to_s)
    expect(json.dig("data", "likeRecording", "errors")).to be_nil
  end

  it "returns an error if the like already exists" do
    recording.likes.create!(user:)
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {id: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "likeRecording", "like")).to be_nil
    expect(json.dig("data", "likeRecording", "errors", "fullMessages")[0]).to eq("User has already liked this")
  end

  it "returns an error if the user is not authenticated" do
    post api_graphql_path, params: {query: mutation, variables: {id: recording.id}}
    json = JSON.parse(response.body)

    expect(json["errors"][0]).to eq("You must be signed in to access this resource.")
  end
end
