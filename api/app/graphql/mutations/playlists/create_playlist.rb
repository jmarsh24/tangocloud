module Mutations::Playlists
  class CreatePlaylist < Mutations::BaseMutation
    argument :title, String, required: true
    argument :description, String, required: false
    argument :item_ids, [ID, null: true], required: false

    field :playlist, Types::PlaylistType, null: true
    field :errors, [String], null: true

    def resolve(title:, description: nil, item_ids: [])
      Playlist.transaction do
        playlist = Playlist.new(title:, description:, user: context[:current_user])

        if playlist.save
          item_ids&.each do |id|
            playlist.playlist_audio_transfers.create!(audio_transfer_id: id)
          end

          {playlist:, errors: []}
        else
          {playlist: nil, errors: playlist.errors.full_messages}
        end
      end
    end
  end
end
