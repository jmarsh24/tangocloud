require "rails_helper"

RSpec.describe "UpdateUser", type: :graph do
  let(:user) { create(:user, :approved) }
  let(:uploaded_file) { Rails.root.join("spec/fixtures/files/di_sarli.jpg") }
  let(:avatar) do
    ApolloUploadServer::Wrappers::UploadedFile.new(
      ActionDispatch::Http::UploadedFile.new(
        tempfile: uploaded_file, filename: File.basename(uploaded_file),
        type: "image/png"
      )
    )
  end

  let(:mutation) do
    <<-GQL
      mutation UpdateUser(
        $username: String,
        $password: String,
        $firstName: String,
        $lastName: String,
        $avatar: Upload
      ) {
        updateUser(input: {
          username: $username,
          firstName: $firstName,
          lastName: $lastName,
          password: $password,
          avatar: $avatar
        }) {
          ... on User {
            username
            userPreference {
              firstName
              lastName
              avatar {
                url
              }
            }
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

  it "updates a user" do
    user.avatar.purge

    variables = {
      firstName: "Updated",
      lastName: "Updated",
      username: "Updated",
      password: "tangocloud!9082",
      avatar:
    }

    gql(mutation, variables:, user:)

    expect(data.update_user.username).to eq("Updated")
    expect(data.update_user.user_preference.first_name).to eq("Updated")
    expect(data.update_user.user_preference.last_name).to eq("Updated")
    expect(data.update_user.user_preference.avatar.url).to be_present
  end
end
