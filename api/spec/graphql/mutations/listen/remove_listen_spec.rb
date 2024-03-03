require "rails_helper"

RSpec.describe "removeListen", type: :request do
  let(:user) { users(:normal) }
  let(:listen) { listens(:volver_a_sonar_normal_listen) }
  let(:recording) { listen.recording }
  let(:mutation) do
    <<~GQL
      mutation removeListen($id: ID!) {
        removeListen(input: {
          id: $id
        }) {
          success
          errors
        }
      }
    GQL
  end

  fit "removes a listen" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {id: listen.id}}, headers: {"Authorization" => "Bearer #{token}"}

    json = JSON.parse(response.body)

    expect(json.dig("data", "removeListen", "success")).to be(true)
    expect(json.dig("data", "removeListen", "errors")).to be_nil

    expect(Listen.exists?(listen.id)).to be false
  end

  it "returns an error if the listen does not exist" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {id: "0"}}, headers: {"Authorization" => "Bearer #{token}"}

    json = JSON.parse(response.body)

    expect(json.dig("data", "removeListen")).to be_nil
    expect(json.dig("errors")[0]["message"]).to eq("Error: Couldn't find Listen with 'id'=0")

    expect(Listen.exists?(listen.id)).to be true
  end

  it "requires authentication" do
    post api_graphql_path, params: {query: mutation, variables: {id: listen.id}}

    json = JSON.parse(response.body)

    expect(json.dig("errors")[0]).to eq("You must be signed in to access this resource.")

    expect(Listen.exists?(listen.id)).to be true
  end
end
