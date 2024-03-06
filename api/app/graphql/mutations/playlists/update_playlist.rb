module Mutations::Playlists
  class UpdatePlaylist < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :image, ApolloUploadServer::Upload, required: false

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(id:, title:, description:, image: nil)
      playlist = Playlist.find(id)

      playlist.title = title
      playlist.description = description

      if image.present?
        playlist.image.attach(io: File.open(image), filename: image.original_filename, content_type: image.content_type)
      end

      if playlist.save
        {
          playlist:,
          errors: []
        }
      else
        {
          playlist: nil,
          errors: playlist.errors.full_messages
        }
      end
    end
  end
end
