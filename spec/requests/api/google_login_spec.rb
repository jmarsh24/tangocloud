require "rails_helper"

RSpec.describe "GoogleLogin", type: :request do
  let(:user) { create(:user, email: "new@google-user.com") }

  before do
    stub_request(:get, "https://example.com/avatar.jpg")
      .to_return(status: 200, body: file_fixture("album-art-volver-a-sonar.jpg").read)

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

  describe "POST /api/google_login" do
    it "creates a new user with google uid" do
      post "/api/google_login", params: {
        id_token: "google-user-identity-token"
      }

      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json["email"]).to eq("new@google-user.com")
      expect(json["session"]["access"]).to be_present
      expect(json["session"]["refresh"]).to be_present
      expect(json["session"]["access_expires_at"]).to be_present
      expect(json["session"]["refresh_expires_at"]).to be_present
    end

    it "logs in an existing user with google uid" do
      user.update!(provider: "google", uid: "google-user-identifier")

      post "/api/google_login", params: {
        id_token: "google-user-identity-token"
      }

      expect(response).to be_successful
      json = JSON.parse(response.body)

      expect(json["email"]).to eq(user.email)
      expect(json["username"]).to eq(user.username)
      expect(json["session"]["access"]).to be_present
      expect(json["session"]["refresh"]).to be_present
      expect(json["session"]["access_expires_at"]).to be_present
      expect(json["session"]["refresh_expires_at"]).to be_present
    end
  end
end
