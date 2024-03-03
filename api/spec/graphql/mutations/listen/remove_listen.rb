require "rails_helper"

RSpec.describe "destroyRecordingListen", type: :request do
  let(:user) { users(:normal) }
  let(:listen) { listens(:volver_a_sonar_normal_listen) }
  let(:recording) { listen.recording }
  let(:mutation) do
    <<~GQL
      mutation destroyRecordingListen($id: ID!) {
        destroyRecordingListen(input: {
          id: $id
        }) {
          success
          errors
        }
      }
    GQL
  end

  it "destroys a listen" do
    token = AuthToken.token(user)
    post api_graphql_path, params: { query: mutation, variables: { id: listen.id } }, headers: { "Authorization" => "Bearer #{token}" }

    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyRecordingListen", "success")).to eq(true)
    expect(json.dig("data", "destroyRecordingListen", "errors")).to be_nil

    expect(RecordingListen.exists?(listen.id)).to be false
  end

  it "returns an error if the listen does not exist" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {id: "0"}}, headers: {"Authorization" => "Bearer #{token}"}

    json = JSON.parse(response.body)

    expect(json.dig("data", "destroyRecordingListen")).to be_nil
    expect(json.dig("errors")[0]["message"]).to eq("Error: Couldn't find RecordingListen with 'id'=0")

    expect(RecordingListen.exists?(listen.id)).to be true
  end

  it "requires authentication" do
    post api_graphql_path, params: { query: mutation, variables: { id: listen.id } }

    json = JSON.parse(response.body)

    expect(json.dig("errors")[0]).to eq("You must be signed in to access this resource.")

    expect(RecordingListen.exists?(listen.id)).to be true
  end
end
