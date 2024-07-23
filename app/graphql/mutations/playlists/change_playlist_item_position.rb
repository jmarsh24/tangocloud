module Mutations::Playlists
  class ChangePlaylistItemPosition < Mutations::BaseMutation
    argument :playlist_item_id, ID, required: true
    argument :position, Integer, required: true

    field :errors, [String], null: false
    field :playlist_item, Types::PlaylistItemType, null: true

    def resolve(playlist_item_id:, position:)
      check_authentication!

      playlist_item = current_user.playlist_items.find_by(id: playlist_item_id)
      return {playlist_item: nil, errors: ["Playlist item not found"]} if playlist_item.nil?

      if position < 1
        return {playlist_item: nil, errors: ["Position must be greater than or equal to 1"]}
      end

      if position > playlist_item.playlist.playlist_items.count
        return {playlist_item: nil, errors: ["Position cannot be greater than the number of items in the playlist"]}
      end

      if playlist_item.update(position:)
        playlist_item.insert_at(position)
        {playlist_item:, errors: []}
      else
        {playlist_item: nil, errors: playlist_item.errors.full_messages}
      end
    end
  end
end
