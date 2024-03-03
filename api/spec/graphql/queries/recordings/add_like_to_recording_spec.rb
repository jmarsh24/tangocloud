require "rails_helper"

RSpec.describe "liked", type: :request do
  describe "query" do
    it "returns true if the user has liked the likeable" do
      user = users(:normal)
      recording = recordings(:volver_a_sonar)
      recording.likes.create(user:)
      token = AuthToken.token(user)

      query = <<~GQL
        query {
          liked(likeableType: "Recording", likeableId: "#{recording.id}")
        }
      GQL

      post api_graphql_path, params: {query:}, headers: {"Authorization" => "Bearer #{token}"}

      json = JSON.parse(response.body)
      data = json.dig("data", "liked")
      expect(data).to be(true)
    end

    it "returns false if the user has not liked the likeable" do
      user = users(:normal)
      recording = recordings(:volver_a_sonar)
      token = AuthToken.token(user)

      query = <<~GQL
        query {
          liked(likeableType: "Recording", likeableId: "#{recording.id}")
        }
      GQL

      post api_graphql_path, params: {query:}, headers: {"Authorization" => "Bearer #{token}"}

      json = JSON.parse(response.body)
      data = json["data"]["liked"]
      expect(data).to be(false)
    end

    it "returns an error if the user is not authenticated" do
      recording = recordings(:volver_a_sonar)

      query = <<~GQL
        query {
          liked(likeableType: "Recording", likeableId: "#{recording.id}")
        }
      GQL

      post api_graphql_path, params: {query:}

      json = JSON.parse(response.body)
      expect(json.dig("errors")[0]).to eq("You must be signed in to access this resource.")
    end
  end
end
