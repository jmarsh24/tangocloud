require "rails_helper"

RSpec.describe "register", type: :graph do
  let(:mutation) do
    <<~GQL
      mutation register($username: String!, $email: String!, $password: String!) {
        register(input: {
          username: $username
          email: $email
          password: $password
        }) {
          user {
            id
            email
            username
          }
        }
      }
    GQL
  end

  it "is successful with correct data" do
    username = "new_user"
    email = "new_user@example.com"
    variables = {
      username:,
      email:,
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(result.data.register.user.email).to eq(email)
    expect(result.data.register.user.username).to eq(username)
    expect(last_mail!.to).to eq("new_user@example.com")
  end

  it "fails in case of wrong email format" do
    wrong_email = "test.user"
    variables = {
      username: "new_user",
      email: wrong_email,
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Email is invalid"])
  end

  it "fails in case of no password" do
    variables = {
      username: "new_user",
      email: "new_user@example.com",
      password: ""
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Password can't be blank"])
  end

  it "fails in case of no username" do
    variables = {
      username: "",
      email: "new_user@example.com",
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Username can't be blank, Username is too short (minimum is 3 characters), Username is invalid"])
  end

  it "fails in case of no email" do
    variables = {
      username: "new_user",
      email: "",
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Email can't be blank, Email is invalid"])
  end

  it "fails in case of duplicate email" do
    email = "new_user@example.com"
    User.create!(username: "new_user", email: "new_user@example.com", password: SecureRandom.hex)
    variables = {
      username: "new_user",
      email:,
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Email has already been taken, Username has already been taken"])
  end

  it "fails in case of duplicate username" do
    username = "new_user"
    email = "new_user@example.com"
    User.create!(username: "new_user", email:, password: SecureRandom.hex)
    variables = {
      username:,
      email:,
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(gql_errors.map(&:message)).to eq(["Validation Error: Email has already been taken, Username has already been taken"])
  end
end
