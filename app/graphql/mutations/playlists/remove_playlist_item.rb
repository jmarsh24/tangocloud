module Mutations::Playlists
  class RemovePlaylistItem < Mutations::BaseMutation
    argument :playlist_item_id, ID, required: true

    field :errors, [String], null: false
    field :success, Boolean, null: false

    def resolve(playlist_item_id:)
      playlist_item = current_user.playlist_items.find_by(id: playlist_item_id)
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
