require "rails_helper"

RSpec.describe "Users::AppleLogin", type: :graph do
  let(:user) { users(:normal) }
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
        headers: { 'Content-Type' => 'application/json' }
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

    expect(result.data.apple_login.user.email).to eq("new@apple-user.com")
    expect(result.data.apple_login.user.first_name).to eq("John")
    expect(result.data.apple_login.user.last_name).to eq("Doe")
    expect(result.data.apple_login.token).to eq(AuthToken.token(User.find_by!(email: "new@apple-user.com")))
  end

  it "logs in an existing user with apple uid" do
    user.update!(provider: "apple", uid: "apple-user-identifier")
    variables = {
      identityToken: "apple-user-identity-token",
      userIdentifier: "apple-user-identifier"
    }

    gql(mutation, variables:)

    expect(result.data.apple_login.user.email).to eq(user.email)
    expect(result.data.apple_login.user.username).to eq(user.username)
    expect(result.data.apple_login.user.first_name).to eq(user.first_name)
    expect(result.data.apple_login.user.last_name).to eq(user.last_name)
    expect(result.data.apple_login.token).to eq(AuthToken.token(user))
  end
end
