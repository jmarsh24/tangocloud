module Mutations::Playlists
  class CreatePlaylist < Mutations::BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :public, Boolean, required: false
    argument :image, ApolloUploadServer::Upload, required: false
    argument :item_ids, [ID], required: false

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: false

    def resolve(title:, description: nil, public: true, image: nil, item_ids: [])
      playlist = Playlist.new(
        title:,
        description:,
        public:,
        user: context[:current_user]
      )

      if image.present?
        playlist.image.attach(
          io: File.open(image),
          filename: image.original_filename,
          content_type: image.content_type
        )
      end

      if item_ids.present?
        item_ids.each_with_index do |item_id, position|
          playlist.playlist_items.build(playable_id: item_id, playable_type: "Recording", position:)
        end
      end

      if playlist.save
        {playlist:, errors: []}
      else
        {playlist: nil, errors: playlist.errors.full_messages}
      end
    end
  end
end
