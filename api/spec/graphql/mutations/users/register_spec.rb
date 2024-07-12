require "rails_helper"

RSpec.describe "register", type: :graph do
  let(:mutation) do
    <<~GQL
      mutation register(
          $username: String,
          $email: String!,
          $password: String!) {
          register(
            input: {
              username: $username,
              email: $email,
              password: $password
            }
          ) {
          ...on AuthenticatedUser {
            id
            username
            email
            access
            accessExpiresAt
            refresh
            refreshExpiresAt
          }
          ...on ValidationError {
            errors {
              fullMessages
              attributeErrors {
                attribute
                errors
              }
            }
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

    expect(result.data.register.email).to eq(email)
    expect(result.data.register.username).to eq(username)
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

    expect(data.register.errors.full_messages).to eq(["Email is invalid"])
  end

  it "fails in case of no password" do
    variables = {
      username: "new_user",
      email: "new_user@example.com",
      password: ""
    }

    gql(mutation, variables:)

    expect(data.register.errors.full_messages).to eq(["Password can't be blank"])
  end

  it "fails in case of no email" do
    variables = {
      username: "new_user",
      email: "",
      password: SecureRandom.hex
    }

    gql(mutation, variables:)

    expect(data.register.errors.full_messages).to eq(["Email can't be blank"])
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

    expect(data.register.errors.full_messages).to eq(["Email has already been taken"])
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

    expect(data.register.errors.full_messages).to eq(["Email has already been taken"])
  end
end
