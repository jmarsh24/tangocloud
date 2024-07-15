module Mutations::Playlists
  class DeletePlaylist < Mutations::BaseMutation
    argument :id, ID, required: true

    field :errors, [String], null: false
    field :success, Boolean, null: false

    def resolve(id:)
      check_authentication!

      playlist = current_user.playlists.find_by(id:)

      if playlist.nil?
        {
          success: false,
          errors: ["Playlist not found."]
        }
      elsif playlist.destroy
        {
          success: true,
          errors: ["Playlist deleted successfully."]
        }
      else
        {
          success: false,
          errors: playlist.errors.full_messages
        }
      end
    end
  end
end
