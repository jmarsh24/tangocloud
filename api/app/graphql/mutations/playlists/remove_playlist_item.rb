module Mutations::Playlists
  class RemovePlaylistItem < Mutations::BaseMutation
    argument :playlist_item_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(playlist_item_id:)
      playlist_item = PlaylistItem.find_by(id: playlist_item_id)
      if playlist_item.nil?
        {success: false, errors: ["Playlist item not found"]}
      elsif playlist_item.destroy
        {success: true, errors: []}
      else
        {success: false, errors: playlist_item.errors.full_messages}
      end
    end
  end
end
