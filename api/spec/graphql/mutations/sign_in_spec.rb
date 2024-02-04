require "rails_helper"

RSpec.describe "#signIn mutation" do
  let!(:user) { users(:normal) }
  let(:mutation) do
    <<~GQL
      mutation signIn($login: String!, $password: String!) {
        signIn(input: {
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
        }
      }
    GQL
  end

  it "is successful with correct email and password" do
    result = TangocloudSchema.execute(mutation, variables: {
      login: user.email,
      password: "password"
    })

    expect(result.dig("data", "signIn", "errors")).to be_nil
    expect(result.dig("data", "signIn", "user", "email")).to eq(user.email)
    expect(result.dig("data", "signIn", "user", "id")).to be_present
    expect(result.dig("data", "signIn", "token")).to be_present
  end

  it "is successful with correct username and password" do
    result = TangocloudSchema.execute(mutation, variables: {
      login: user.username,
      password: "password"
    })

    expect(result.dig("data", "signIn", "errors")).to be_nil
    expect(result.dig("data", "signIn", "user", "email")).to eq(user.email)
    expect(result.dig("data", "signIn", "user", "id")).to be_present
    expect(result.dig("data", "signIn", "token")).to be_present
  end

  it "fails with wrong username" do
    result = TangocloudSchema.execute(mutation, variables: {
      login: "wrong-username",
      password: "password"
    })

    expect(result.dig("data", "signIn", "user", "id")).to be_nil
    expect(result.dig("data", "signIn", "token")).to be_nil
    expect(result.dig("errors", 0, "message")).to eq("Incorrect Email/Password")
  end

  it "fails with wrong password" do
    result = TangocloudSchema.execute(mutation, variables: {
      login: "user@example.com",
      password: "wrong-password"
    })

    expect(result.dig("data", "signIn", "user", "id")).to be_nil
    expect(result.dig("data", "signIn", "token")).to be_nil
    expect(result.dig("errors", 0, "message")).to eq("Incorrect Email/Password")
  end

  it "fails with wrong email" do
    result = TangocloudSchema.execute(mutation, variables: {
      login: "wrong@email.com",
      password: "wrong-password"
    })

    expect(result.dig("data", "signIn", "user", "id")).to be_nil
    expect(result.dig("data", "signIn", "token")).to be_nil
    expect(result.dig("errors", 0, "message")).to eq("Incorrect Email/Password")
  end
end
