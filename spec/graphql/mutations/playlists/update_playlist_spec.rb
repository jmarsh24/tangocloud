require "rails_helper"

RSpec.describe "UpdatePlaylist", type: :graph do
  let(:user) { create(:user, :approved) }
  let(:playlist) { create(:playlist, user:) }
  let(:uploaded_file) { Rails.root.join("spec/fixtures/files/di_sarli.jpg") }
  let(:image) do
    ApolloUploadServer::Wrappers::UploadedFile.new(
      ActionDispatch::Http::UploadedFile.new(
        tempfile: uploaded_file, filename: File.basename(uploaded_file),
        type: "image/png"
      )
    )
  end

  let(:mutation) do
    <<-GQL
      mutation UpdatePlaylist(
        $id: ID!,
        $title: String,
        $description: String,
        $public: Boolean,
        $image: Upload
      ) {
        updatePlaylist(input: {
          id: $id,
          title: $title,
          description: $description,
          public: $public,
          image: $image
        }) {
          playlist {
            id
            title
            description
            image {
              blob {
                url
              }
            }
            public
          }
          errors
        }
      }
    GQL
  end

  it "updates a playlist" do
    playlist.image.purge

    variables = {
      id: playlist.id,
      title: "Updated Playlist",
      description: "This is an updated playlist",
      public: false,
      image:
    }

    gql(mutation, variables:, user: playlist.user)

    expect(result.data.update_playlist.playlist).to have_attributes(
      title: "Updated Playlist",
      description: "This is an updated playlist",
      public: false
    )
    expect(result.data.update_playlist.playlist.image.blob.url).to be_present
    expect(result.data.update_playlist.errors).to be_empty
  end
end
