require "rails_helper"

RSpec.describe "Users::AppleLogin", type: :graph do
  let(:user) { create(:user, email: "new@apple-user.com") }
  let(:mutation) do
    <<~GQL
      mutation appleLogin($userIdentifier: String!, $identityToken: String!, $email: String, $firstName: String, $lastName: String) {
        appleLogin(input: {
          userIdentifier: $userIdentifier
          identityToken: $identityToken
          email: $email
          firstName: $firstName
          lastName: $lastName
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

  it "creates a new user with apple uid" do
    variables = {
      userIdentifier: "apple-user-identifier",
      identityToken: "apple-user-identity-token",
      email: "new@apple-user.com",
      firstName: "John",
      lastName: "Doe"
    }

    gql(mutation, variables:)

    expect(data.apple_login["__typename"]).to eq("AuthenticatedUser")
    expect(data.apple_login.email).to eq("new@apple-user.com")
    expect(data.apple_login.session.access).to be_present
    expect(data.apple_login.session.refresh).to be_present
    expect(data.apple_login.session.access_expires_at).to be_present
    expect(data.apple_login.session.refresh_expires_at).to be_present
  end

  it "logs in an existing user with apple uid" do
    user.update!(provider: "apple", uid: "apple-user-identifier")
    variables = {
      identityToken: "apple-user-identity-token",
      userIdentifier: "apple-user-identifier"
    }
    gql(mutation, variables:)

    expect(data.apple_login["__typename"]).to eq("AuthenticatedUser")

    expect(data.apple_login.email).to eq(user.email)
    expect(data.apple_login.username).to eq(user.username)
    expect(data.apple_login.session.access).to be_present
    expect(data.apple_login.session.refresh).to be_present
    expect(data.apple_login.session.access_expires_at).to be_present
    expect(data.apple_login.session.refresh_expires_at).to be_present
  end
end
