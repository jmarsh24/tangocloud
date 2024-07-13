require "rails_helper"

RSpec.describe "GraphQL, login mutation", type: :graph do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "SecurePassword1",
      username: "TestUser"
    )
  end

  let(:mutation) do
    <<~GQL
      mutation login($login: String!, $password: String!) {
        login(
          input: {
            login: $login,
            password: $password,
          }
        ) {
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

  it "logs in successfully" do
    variables = {
      login: user.email,
      password: "SecurePassword1"
    }

    gql(mutation, variables:)

    expect(data.login["__typename"]).to eq("AuthenticatedUser")
    expect(data.login["email"]).to eq("test@example.com")
    expect(data.login.session["access"]).to be_present
  end

  it "cannot log in with an invalid password" do
    variables = {
      login: user.email,
      password: "password"
    }

    gql(mutation, variables:)

    expect(data.login["__typename"]).to eq("FailedLogin")
    expect(data.login["error"]).to eq("Invalid login credentials")
  end
end
