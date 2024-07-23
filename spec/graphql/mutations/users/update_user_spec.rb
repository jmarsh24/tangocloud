require "rails_helper"

RSpec.describe "UpdateUser", type: :graph do
  let(:user) { create(:user) }
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
        $firstName: String,
        $lastName: String,
        $password: String,
        $avatar: Upload
      ) {
        updateUser(input: {
          firstName: $firstName,
          lastName: $lastName,
          password: $password,
          avatar: $avatar
        }) {
          ... on User {
            name
            userPreference {
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
      password: "tangocloud!9082",
      avatar:
    }

    gql(mutation, variables:, user:)

    expect(data.update_user.name).to eq("Updated Updated")
    expect(data.update_user.user_preference.avatar.url).to be_present
  end
end
