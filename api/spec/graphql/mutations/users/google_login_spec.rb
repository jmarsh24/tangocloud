require "rails_helper"

RSpec.describe "Users::GoogleLogin", type: :graph do
  let(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation googleLogin($idToken: String!) {
        googleLogin(input: {
          idToken: $idToken
        }) {
          user {
            id
            username
            email
            firstName
            lastName
          }
          token
        }
      }
    GQL
  end

  before do
    stub_request(:get, "https://example.com/avatar.jpg").to_return(status: 200, body: file_fixture("album-art-volver-a-sonar.jpg").read)
    allow(Google::Auth::IDTokens).to receive(:verify_oidc).and_return(
      {
        "iss" => "https://accounts.google.com",
        "azp" => "YOUR_CLIENT_ID.apps.googleusercontent.com",
        "aud" => "YOUR_CLIENT_ID.apps.googleusercontent.com",
        "sub" => "google-user-identifier",
        "email" => "new@google-user.com",
        "email_verified" => true,
        "at_hash" => "test_at_hash",
        "nonce" => "test_nonce",
        "name" => "John Doe",
        "picture" => "https://example.com/avatar.jpg",
        "given_name" => "John",
        "family_name" => "Doe",
        "iat" => 1718552040,
        "exp" => 1718555640
      }
    )
  end

  it "creates a new user with google uid" do
    variables = {
      idToken: "google-user-identity-token"
    }

    gql(mutation, variables:)

    expect(result.data.google_login.user.email).to eq("new@google-user.com")
    expect(result.data.google_login.user.first_name).to eq("John")
    expect(result.data.google_login.user.last_name).to eq("Doe")
    expect(result.data.google_login.token).to eq(AuthToken.token(User.find_by!(email: "new@google-user.com")))
  end

  it "logs in an existing user with google uid" do
    user.update!(provider: "google", uid: "google-user-identifier")
    variables = {
      idToken: "google-user-identity-token"
    }

    gql(mutation, variables:)

    expect(result.data.google_login.user.email).to eq(user.email)
    expect(result.data.google_login.user.username).to eq(user.username)
    expect(result.data.google_login.user.first_name).to eq(user.first_name)
    expect(result.data.google_login.user.last_name).to eq(user.last_name)
    expect(result.data.google_login.token).to eq(AuthToken.token(user))
  end
end
