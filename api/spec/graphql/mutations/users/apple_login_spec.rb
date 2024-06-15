require "rails_helper"

RSpec.describe "Users::AppleLogin", type: :graph do
  let!(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation appleLogin($userIdentifier: String!, $email: String, $firstName: String, $lastName: String) {
        appleLogin(input: {
          userIdentifier: $userIdentifier
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

  it "creates a new user with apple uid" do
    variables = {
      userIdentifier: "apple-user-identifier",
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

  it "logins a user with apple uid" do
    user.update!(provider: "apple", uid: "apple-user-identifier")
    variables = {
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
