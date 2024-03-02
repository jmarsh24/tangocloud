require "rails_helper"

RSpec.describe "CreateLike", type: :request do
  let(:user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:mutation) do
    <<~GQL
      mutation CreateLike($likeableType: String!, $likeableId: ID!) {
        createLike(input: { likeableType: $likeableType, likeableId: $likeableId }) {
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
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "createLike", "like", "user", "id")).to eq(user.id.to_s)
    expect(json.dig("data", "createLike", "like", "likeableType")).to eq("Recording")
    expect(json.dig("data", "createLike", "like", "likeableId")).to eq(recording.id.to_s)
    expect(json.dig("data", "createLike", "errors")).to be_nil
  end

  it "returns an error if the like already exists" do
    recording.likes.create!(user:)
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "createLike", "like")).to be_nil
    expect(json.dig("data", "createLike", "errors", "fullMessages")[0]).to eq("User has already liked this")
  end

  it "returns an error if the likeable type is invalid" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Invalid", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "createLike", "like")).to be_nil
    expect(json.dig("errors", 0, "message")).to eq("Likeable type is not a valid type")
  end

  it "returns an error if the user is not authenticated" do
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}
    json = JSON.parse(response.body)

    expect(json.dig("data", "createLike", "errors", "fullMessages")[0]).to eq("User must exist")
  end
end
