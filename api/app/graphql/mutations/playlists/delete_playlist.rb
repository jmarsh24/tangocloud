module Mutations::Playlists
  class DeletePlaylist < Mutations::BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve(id:)
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
