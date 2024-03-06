require "rails_helper"

RSpec.describe "login", type: :graph do
  let!(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation login($login: String!, $password: String!) {
        login(input: {
          login: $login
          password: $password
        }) {
          user {
            id
            username
            email
            name
          }
          token
          success
          errors {
            message
          }
        }
      }
    GQL
  end

  it "is successful with correct email and password" do
    variables = {
      login: user.email,
      password: "password"
    }

    gql(mutation, variables:)

    expect(result.data.login.success).to be(true)
    expect(result.data.login.errors).to be_empty
    expect(result.data.login.user.email).to eq(user.email)
    expect(result.data.login.user.id).to be_present
    expect(result.data.login.token).to be_present
  end

  it "is successful with correct username and password" do
    variables = {
      login: user.username,
      password: "password"
    }

    gql(mutation, variables:)

    expect(result.data.login.success).to be(true)
    expect(result.data.login.errors).to be_empty
    expect(result.data.login.user.email).to eq(user.email)
    expect(result.data.login.user.id).to be_present
    expect(result.data.login.token).to be_present
  end

  it "fails with wrong username" do
    variables = {
      login: "wrong-username",
      password: "password"
    }

    gql(mutation, variables:)

    expect(result.data.login.success).to be(false)
    expect(result.data.login.user).to be_nil
    expect(result.data.login.token).to be_nil
    expect(result.data.login.errors[0].message).to eq("Incorrect Email/Password")
  end

  it "fails with wrong password" do
    variables = {
      login: "user@example.com",
      password: "wrong-password"
    }

    gql(mutation, variables:)

    expect(result.data.login.success).to be(false)
    expect(result.data.login.user).to be_nil
    expect(result.data.login.token).to be_nil
    expect(result.data.login.errors[0].message).to eq("Incorrect Email/Password")
  end

  it "fails with wrong email" do
    variables = {
      login: "wrong@email.com",
      password: "wrong-password"
    }

    gql(mutation, variables:)

    expect(result.data.login.success).to be(false)
    expect(result.data.login.user).to be_nil
    expect(result.data.login.token).to be_nil
    expect(result.data.login.errors[0].message).to eq("Incorrect Email/Password")
  end
end
