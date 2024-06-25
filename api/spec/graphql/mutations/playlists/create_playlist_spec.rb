# spec/graphql/mutations/playlists/create_playlist_spec.rb
require "rails_helper"

RSpec.describe "CreatePlaylist", type: :graph do
  let(:user) { users(:normal) }
  let(:recording1) { recordings(:volver_a_sonar) }
  let(:recording2) { recordings(:milonga_vieja_milonga) }
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
    <<~GQL
      mutation CreatePlaylist(
        $title: String!,
        $description: String,
        $public: Boolean,
        $image: Upload,
        $itemIds: [ID!]
      ) {
        createPlaylist(input: {
          title: $title,
          description: $description,
          public: $public,
          image: $image,
          itemIds: $itemIds
        }) {
          playlist {
            id
            title
            description
            public
            image {
              blob {
                url
              }
            }
            playlistItems {
              edges {
                node {
                  item {
                    ... on Recording {
                      id
                    }
                  }
                }
              }
            }
          }
        }
      }
    GQL
  end

  it "creates a playlist with items" do
    variables = {
      title: "New Playlist",
      description: "This is a new playlist",
      public: true,
      image:,
      itemIds: [recording1.id, recording2.id]
    }

    gql(mutation, variables:, user:)

    expect(result.data.create_playlist.playlist).to have_attributes(
      title: "New Playlist",
      description: "This is a new playlist",
      public: true
    )
    expect(result.data.create_playlist.playlist.image.blob.url).to be_present
    expect(result.data.create_playlist.playlist.playlist_items.edges.map { |edge| edge.node.item.id }).to match_array([recording1.id, recording2.id])
  end
end
