module Mutations::Playlists
  class RemovePlaylistItem < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(id:)
      playlist_item = PlaylistItem.find(id)

      if playlist_item.destroy
        {message: "Playlist item successfully deleted"}
      else
        {errors: playlist_item.errors}
      end
    rescue ActiveRecord::RecordNotFound => e
      GraphQL::ExecutionError.new("Error: #{e.message}")
    end
  end
end
