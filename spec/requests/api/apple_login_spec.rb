require "rails_helper"

RSpec.describe "AppleLogin", type: :request do
  let(:user) { create(:user, email: "new@apple-user.com") }

  before do
    stub_request(:get, "https://appleid.apple.com/auth/keys")
      .to_return(
        status: 200,
        body: {
          keys: [
            {
              kty: "RSA",
              kid: "eXaunmL",
              use: "sig",
              alg: "RS256",
              n: "valid_key_n_value",
              e: "AQAB"
            }
          ]
        }.to_json,
        headers: {"Content-Type" => "application/json"}
      )

    allow_any_instance_of(AppleToken).to receive(:decode_identity_token).and_return(
      {
        "iss" => "https://appleid.apple.com",
        "aud" => "tangocloud",
        "exp" => 1718553201,
        "iat" => 1718466801,
        "sub" => "apple-user-identifier",
        "email" => "new@apple-user.com",
        "email_verified" => true
      }
    )
  end

  describe "POST /api/apple_login" do
    it "creates a new user with apple uid" do
      post "/api/apple_login", params: {
        user_identifier: "apple-user-identifier",
        identity_token: "apple-user-identity-token",
        email: "new@apple-user.com",
        first_name: "John",
        last_name: "Doe"
      }

      expect(response).to be_successful
      json = JSON.parse(response.body)

      expect(json["email"]).to eq("new@apple-user.com")
      expect(json["session"]["access"]).to be_present
      expect(json["session"]["refresh"]).to be_present
      expect(json["session"]["access_expires_at"]).to be_present
      expect(json["session"]["refresh_expires_at"]).to be_present
    end

    it "logs in an existing user with apple uid" do
      user.update!(provider: "apple", uid: "apple-user-identifier")

      post "/api/apple_login", params: {
        identity_token: "apple-user-identity-token",
        user_identifier: "apple-user-identifier"
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
