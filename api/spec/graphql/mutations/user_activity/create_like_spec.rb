require "rails_helper"

RSpec.describe "CreateLike", type: :request do
  let(:user) { users(:normal) }
  let(:recording) { recordings(:volver_a_sonar) }
  let(:mutation) do
    <<~GQL
      mutation createLike($likeableType: String!, $likeableId: ID!) {
        createLike(input: {
          likeableType: $likeable_type
          likeableId: $id
        }) {
            like {
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
      }
    GQL
  end

  it "creates a listen" do
    token = AuthToken.token(user)
    post api_graphql_path, params: {query: mutation, variables: {likeableType: "Recording", likeableId: recording.id}}, headers: {"Authorization" => "Bearer #{token}"}
    json = JSON.parse(response.body)
    debugger
    expect(json.dig("data", "CreateLike", "listen", "user", "id")).to eq(user.id.to_s)
    expect(json.dig("data", "CreateLike", "listen", "recording", "id")).to eq(recording.id.to_s)
    expect(json.dig("data", "CreateLike", "errors")).to be_empty
  end
end
