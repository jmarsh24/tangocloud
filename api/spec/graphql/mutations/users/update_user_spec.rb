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
        $email: String,
        $password: String,
        $avatar: Upload
      ) {
        updateUser(input: {
          firstName: $firstName,
          lastName: $lastName,
          email: $email,
          password: $password,
          avatar: $avatar
        }) {
          user {
            id
            name
            firstName
            lastName
            name
            email
            avatar {
              blob {
                url
              }
            }
          }
          errors
        }
      }
    GQL
  end

  xit "updates a user" do
    user.avatar.purge

    variables = {
      firstName: "Updated",
      lastName: "Updated",
      email: "updated@example.com",
      password: "tangocloud!9082",
      avatar:
    }

    gql(mutation, variables:, user:)

    expect(data.update_user.user).to have_attributes(
      name: "Updated Updated",
      email: "updated@example.com"
    )
    expect(data.update_user.user.avatar.blob.url).to be_present
    expect(data.update_user.errors).to be_empty
  end
end
