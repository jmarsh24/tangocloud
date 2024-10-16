module Mutations::Playlists
  class UpdatePlaylist < Mutations::BaseMutation
    argument :description, String, required: false
    argument :id, ID, required: true
    argument :image, ApolloUploadServer::Upload, required: false
    argument :public, Boolean, required: false
    argument :title, String, required: false

    field :errors, [String], null: true
    field :playlist, Types::PlaylistType, null: true

    def resolve(id:, title: nil, description: nil, public: nil, image: nil)
      playlist = current_user.playlists.find(id)

      playlist.title = title if title.present?
      playlist.description = description if description.present?
      playlist.public = public unless public.nil?

      if image.present?
        playlist.image.attach(
          io: File.open(image),
          filename: image.original_filename,
          content_type: image.content_type
        )
      end

      if playlist.save
        {playlist:, errors: []}
      else
        {playlist: nil, errors: playlist.errors.full_messages}
      end
    end
  end
end
