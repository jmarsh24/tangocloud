# spec/graphql/mutations/playlists/create_playlist_spec.rb
require "rails_helper"

RSpec.describe "CreatePlaylist", type: :graph do
  let(:user) { create(:user, :approved) }
  let(:volver_a_sonar_composition) { create(:composition, title: "Volver a soñar") }
  let(:milonga_vieja_composition) { create(:composition, title: "Milonga vieja") }
  let(:volver_a_sonar) { create(:recording, composition: volver_a_sonar_composition) }
  let(:milonga_vieja) { create(:recording, composition: milonga_vieja_composition) }
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
              url
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
      itemIds: [volver_a_sonar.id, milonga_vieja.id]
    }

    gql(mutation, variables:, user:)

    expect(result.data.create_playlist.playlist).to have_attributes(
      title: "New Playlist",
      description: "This is a new playlist",
      public: true
    )
    expect(result.data.create_playlist.playlist.image.url).to be_present
    expect(result.data.create_playlist.playlist.playlist_items.edges.map { |edge| edge.node.item.id }).to match_array([volver_a_sonar.id, milonga_vieja.id])
  end
end
