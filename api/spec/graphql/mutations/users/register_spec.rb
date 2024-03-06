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
          success
          errors {
            details
            fullMessages
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
    expect(result.data.register.success).to be(true)
    expect(result.data.register.errors).to be_nil
  end

  it "fails in case of wrong email format" do
    wrong_email = "test.user"
    variables = {
      username: "new_user",
      email: wrong_email,
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)

    expect(result.data.register.errors.details).to eq("{\"email\":[{\"error\":\"invalid\",\"value\":\"#{wrong_email}\"}]}")
    expect(result.data.register.errors.full_messages).to include("Email is invalid")
  end

  it "fails in case of no password" do
    variables = {
      username: "new_user",
      email: "new_user@example.com",
      password: ""
    }

    gql(mutation, variables:)

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)
    expect(result.data.register.errors.details).to eq("{\"password\":[{\"error\":\"blank\"}]}")
    expect(result.data.register.errors.full_messages).to include("Password can't be blank")
  end

  it "fails in case of no username" do
    variables = {
      username: "",
      email: "new_user@example.com",
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)
    expect(result.data.register.errors.details).to eq("{\"username\":[{\"error\":\"blank\"},{\"error\":\"too_short\",\"count\":3},{\"error\":\"invalid\",\"value\":\"\"}]}")
    expect(result.data.register.errors.full_messages).to include("Username can't be blank")
  end

  it "fails in case of no email" do
    variables = {
      username: "new_user",
      email: "",
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)
    expect(result.data.register.errors.details).to eq("{\"email\":[{\"error\":\"blank\"},{\"error\":\"invalid\",\"value\":\"\"}]}")
    expect(result.data.register.errors.full_messages).to include("Email can't be blank")
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

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)
    expect(result.data.register.errors.details).to eq("{\"email\":[{\"error\":\"taken\",\"value\":\"new_user@example.com\"}],\"username\":[{\"error\":\"taken\",\"value\":\"new_user\"}]}")
    expect(result.data.register.errors.full_messages).to include("Email has already been taken")
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

    expect(result.data.register.user).to be_nil
    expect(result.data.register.success).to be(false)
    expect(result.data.register.errors.details).to eq("{\"email\":[{\"error\":\"taken\",\"value\":\"new_user@example.com\"}],\"username\":[{\"error\":\"taken\",\"value\":\"new_user\"}]}")
    expect(result.data.register.errors.full_messages).to include("Username has already been taken")
  end
end
