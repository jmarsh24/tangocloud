require "rails_helper"

RSpec.describe "#signUp mutation" do
  let(:mutation) do
    <<~GQL
        mutation signUp($username: String!, $email: String!, $password: String!) {
          signUp(input: {
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
    result = TangocloudSchema.execute(mutation, variables: {
      username:,
      email:,
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user", "email")).to eq(email)
    expect(result.dig("data", "signUp", "user", "username")).to eq(username)
    expect(result.dig("data", "signUp", "success")).to be(true)
    expect(result.dig("data", "signUp", "errors")).to be_nil
  end

  it "fails in case of wrong email format" do
    wrong_email = "test.user"
    result = TangocloudSchema.execute(mutation, variables: {
      username: "new_user",
      email: wrong_email,
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"email\":[{\"error\":\"invalid\",\"value\":\"#{wrong_email}\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Email is invalid")
  end

  it "fails in case of no password" do
    result = TangocloudSchema.execute(mutation, variables: {
      username: "new_user",
      email: "new_user@example.com",
      password: ""
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"password\":[{\"error\":\"blank\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Password can't be blank")
  end

  it "fails in case of no username" do
    result = TangocloudSchema.execute(mutation, variables: {
      username: "",
      email: "new_user@example.com",
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"username\":[{\"error\":\"blank\"},{\"error\":\"too_short\",\"count\":3},{\"error\":\"invalid\",\"value\":\"\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Username can't be blank")
  end

  it "fails in case of no email" do
    result = TangocloudSchema.execute(mutation, variables: {
      username: "new_user",
      email: "",
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"email\":[{\"error\":\"blank\"},{\"error\":\"invalid\",\"value\":\"\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Email can't be blank")
  end

  it "fails in case of duplicate email" do
    email = "new_user@example.com"
    User.create!(username: "new_user", email: "new_user@example.com", password: SecureRandom.hex)
    result = TangocloudSchema.execute(mutation, variables: {
      username: "new_user",
      email:,
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"email\":[{\"error\":\"taken\",\"value\":\"new_user@example.com\"}],\"username\":[{\"error\":\"taken\",\"value\":\"new_user\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Email has already been taken")
  end

  it "fails in case of duplicate username" do
    username = "new_user"
    email = "new_user@example.com"
    User.create!(username: "new_user", email:, password: SecureRandom.hex)
    result = TangocloudSchema.execute(mutation, variables: {
      username:,
      email:,
      password: SecureRandom.hex
    })

    expect(result.dig("data", "signUp", "user")).to be_nil
    expect(result.dig("data", "signUp", "success")).to be(false)
    expect(result.dig("data", "signUp", "errors", "details")).to eq("{\"email\":[{\"error\":\"taken\",\"value\":\"new_user@example.com\"}],\"username\":[{\"error\":\"taken\",\"value\":\"new_user\"}]}")
    expect(result.dig("data", "signUp", "errors", "fullMessages")).to include("Username has already been taken")
  end
end
