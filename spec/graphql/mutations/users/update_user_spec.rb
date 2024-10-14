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
        $avatar: Upload
      ) {
        updateUser(input: {
          username: $username,
          password: $password,
          avatar: $avatar
        }) {
          ... on User {
            username
            avatar {
              url
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
      username: "Updated",
      password: "tangocloud!9082",
      avatar:
    }

    gql(mutation, variables:, user:)

    expect(data.update_user.username).to eq("Updated")
    expect(data.update_user.avatar.url).to be_present
  end
end
