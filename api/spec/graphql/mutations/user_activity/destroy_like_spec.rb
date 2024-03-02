require "rails_helper"

RSpec.describe "destroyLike", type: :request do
  let(:user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:mutation) do
    <<~GQL
      mutation destroyLike($likeableType: String!, $likeableId: ID!) {
        destroyLike(input: { likeableType: $likeableType likeableId: $likeableId}) {
          success
          errors {
            details
            fullMessages
          }
        }
      }
    GQL
  end

  it "destroys a like" do
    recording.likes.create!(user:)
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyLike", "success")).to be_truthy
    expect(json.dig("data", "destroyLike", "errors")).to be_nil
  end

  it "returns an error if the like does not exist" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyLike", "success")).to be_falsey
    expect(json.dig("errors", 0, "message")).to eq("Like not found")
  end

  it "returns an error if the likeable type is invalid" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Invalid", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyLike", "success")).to be_falsey
    expect(json.dig("errors", 0, "message")).to eq("Like not found")
  end

  fit "returns an error if the user is not authenticated" do
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}
    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyLike")).to be_nil
    expect(json.dig("errors")[0]).to eq("You must be signed in to access this resource.")
  end
end
