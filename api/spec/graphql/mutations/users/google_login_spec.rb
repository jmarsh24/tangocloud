require "rails_helper"

RSpec.describe "Users::GoogleLogin", type: :graph do
  let(:user) { create(:user, email: "new@google-user.com") }
  let(:mutation) do
    <<~GQL
      mutation googleLogin($idToken: String!) {
        googleLogin(input: {
          idToken: $idToken
        }) {
         __typename
          ...on AuthenticatedUser {
            id
            email
            username
            session {
              access
              accessExpiresAt
              refresh
              refreshExpiresAt
            }
          }
          ...on FailedLogin {
            error
          }
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

    expect(data.google_login.email).to eq("new@google-user.com")
    expect(data.google_login.session.access).to be_present
    expect(data.google_login.session.refresh).to be_present
    expect(data.google_login.session.access_expires_at).to be_present
    expect(data.google_login.session.refresh_expires_at).to be_present
  end

  it "logs in an existing user with google uid" do
    user.update!(provider: "google", uid: "google-user-identifier")
    variables = {
      idToken: "google-user-identity-token"
    }
    gql(mutation, variables:)
    expect(data.google_login["__typename"]).to eq("AuthenticatedUser")
    expect(data.google_login.email).to eq(user.email)
    expect(data.google_login.username).to eq(user.username)
    expect(data.google_login.session.access).to be_present
    expect(data.google_login.session.refresh).to be_present
    expect(data.google_login.session.access_expires_at).to be_present
    expect(data.google_login.session.refresh_expires_at).to be_present
  end
end
